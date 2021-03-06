#include "SofaLinkCompletionModel.h"
#include <sofa/core/objectmodel/Base.h>
#include <SofaSimulationGraph/DAGNode.h>
#include <sofa/core/ObjectFactory.h>

namespace sofaqtquick {

using namespace sofa::core::objectmodel;

void SofaLinkCompletionModel::setSofaData(sofaqtquick::bindings::_sofadata_::SofaData *newSofaData)
{
    if (!newSofaData) return;

    m_sofaData = newSofaData;
    m_sofaLink = nullptr;
    sofa::core::objectmodel::Base* base = newSofaData->rawData()->getOwner();
    m_relativeRoot = base->toBaseNode();
    if (!m_relativeRoot) {
        sofa::core::objectmodel::BaseObject* baseobject = base->toBaseObject();
        if (baseobject) {
            m_relativeRoot = baseobject->getContext()->toBaseNode();
        } else {
            msg_error("SofaLinkCompletionModel") << "Can't fetch links: sofaData " + m_sofaData->getName().toStdString() + " has no context.";
        }
    }
    m_absoluteRoot = m_relativeRoot->getRoot();
    updateModel();
    emit sofaLinkChanged(nullptr);
    emit sofaDataChanged(newSofaData);
}

void SofaLinkCompletionModel::setSofaLink(sofaqtquick::bindings::_sofalink_::SofaLink* newSofaLink)
{
    if (!newSofaLink) return;

    m_sofaLink = newSofaLink;
    m_sofaData = nullptr;
    sofa::core::objectmodel::Base* base = newSofaLink->self()->getOwnerBase();
    m_relativeRoot = base->toBaseNode();
    if (!m_relativeRoot) {
        sofa::core::objectmodel::BaseObject* baseobject = base->toBaseObject();
        if (baseobject) {
            m_relativeRoot = baseobject->getContext()->toBaseNode();
        } else {
            msg_error("SofaLinkCompletionModel") << "Can't fetch links: sofaLink " + m_sofaLink->self()->getName() + " has no context.";
        }
    }
    m_absoluteRoot = m_relativeRoot->getRoot();
    updateModel();
    setIsComponent(true); // Always components with SofaLinks
    emit sofaDataChanged(nullptr);
    emit sofaLinkChanged(newSofaLink);
}

void SofaLinkCompletionModel::setLinkPath(QString newlinkPath)
{
    std::cout << "c++: " << newlinkPath.toStdString() << std::endl;
    m_linkPath = newlinkPath;
    updateModel();
    emit linkPathChanged(newlinkPath);
}


Base* SofaLinkCompletionModel::getLastValidObject(QString& lastValidLinkPath)
{
    lastValidLinkPath = "";
    if (!m_linkPath.startsWith("@"))
        return nullptr;

    QString linkpath = m_linkPath.remove(0, 1);
    QStringList strlist = m_linkPath.split("/");
    BaseNode* root = m_relativeRoot->toBaseNode();
    int i = -1;
    bool lastIsChild = false;
    for (auto s : strlist)
    {
        lastIsChild = false;
        i++;

        if (i == 0 && s == "") // If First character is root
        {
            lastValidLinkPath.push_back(s);
            lastValidLinkPath.push_back("/");
            root = m_absoluteRoot->toBaseNode();
        }
        else if (s == "" && i != strlist.size() - 1) // if a path is empty (double slash //)
        {
            return nullptr;
        }
        else if (s == "..")
        {
            lastValidLinkPath.push_back(s);
            lastValidLinkPath.push_back("/");
            if (root->getFirstParent() != nullptr)
                root = root->getFirstParent();
        }
        else if (s == ".")
        {
            lastValidLinkPath.push_back(s);
            lastValidLinkPath.push_back("/");
            continue;
        }
        else
        {
            if (i == strlist.size() - 1) {
                if (s.contains(".")) {
                    s = s.split(".")[0];
                }
            }
            auto n = static_cast<sofa::simulation::Node*>(root);
            if (!n) return nullptr;
            if (n->getChild(s.toStdString()) != nullptr)
            {
                lastValidLinkPath.push_back(s);
                lastValidLinkPath.push_back("/");
                lastIsChild = true;
                root = n->getChild(s.toStdString());
            }
            else if (n->getObject(s.toStdString()) != nullptr) {
                lastValidLinkPath.push_back(s);
                return n->getObject(s.toStdString());
            }
            else {
                msg_error("") << "no item named " << s.toStdString() << " in " << n->getPathName();
                return root;
            }

        }
    }
    if (lastIsChild)
        lastValidLinkPath.chop(1);
    return root;
}

void SofaLinkCompletionModel::updateModel()
{
    if (!m_sofaData && !m_sofaLink) return;
    beginResetModel();
    QString lastValidLinkPath = "";
    std::string path_separator = "/";
    std::string data_separator = ".";
    Base* lastValid = this->getLastValidObject(lastValidLinkPath);
    if (lastValidLinkPath == "")
    {
        path_separator = "";
        data_separator = "";
    }
    else if (lastValidLinkPath[lastValidLinkPath.size() -1] == "/")
        path_separator = "";
    else if (lastValidLinkPath[lastValidLinkPath.size() -1] == ".")
        data_separator = "";
    m_modelText.clear();
    m_modelName.clear();
    m_modelHelp.clear();
    m_modelCanLink.clear();

    if (!lastValid) {
        endResetModel();
        return;
    }

    if (lastValid->toBaseNode())
    {
        BaseNode* node = lastValid->toBaseNode();
        for (auto child : node->getChildren())
        {
            m_modelText.push_back(lastValidLinkPath+QString::fromStdString(path_separator+child->getName()));
            m_modelName.push_back(QString::fromStdString(child->getName()));
            m_modelHelp.push_back(QString::fromStdString(child->getTypeName()));
            m_modelCanLink.push_back(true);
        }
        sofa::simulation::graph::DAGNode* n = static_cast<sofa::simulation::graph::DAGNode*>(node);
        for (auto object : n->object)
        {
            m_modelText.push_back(lastValidLinkPath+QString::fromStdString(path_separator+object->getName()));
            m_modelName.push_back(QString::fromStdString(object->getName()));
            m_modelHelp.push_back(QString::fromStdString(
                                      sofa::core::ObjectFactory::getInstance()
                                      ->getEntry(object->getClassName()).description));
            m_modelCanLink.push_back(true);
        }
    }

    QStringList modelText, modelName, modelHelp;
    QList<bool> modelCanLink;
    if (!m_isComponent)
    {

        if (!m_sofaData) return;
        for (auto data : lastValid->getDataFields())
        {
            if (data->getValueTypeString() == sofaData()->rawData()->getValueTypeString())
            {
                m_modelText.push_back(lastValidLinkPath+QString::fromStdString(data_separator+data->getName()));
                m_modelName.push_back(QString::fromStdString(data->getName()));
                m_modelHelp.push_back(QString::fromStdString(data->getHelp()));
                m_modelCanLink.push_back(true);
            }
            else
            {
                modelText.push_back(lastValidLinkPath+QString::fromStdString(data_separator+data->getName()));
                modelName.push_back(QString::fromStdString(data->getName()));
                modelHelp.push_back(QString::fromStdString(data->getHelp()));
                modelCanLink.push_back(false);
            }
        }
        m_modelText += modelText;
        m_modelName += modelName;
        m_modelHelp += modelHelp;
        m_modelCanLink += modelCanLink;
        modelText.clear();
        modelName.clear();
        modelHelp.clear();
        modelCanLink.clear();
    }
    for (int i = 0 ; i < m_modelText.size() ; ++i)
    {
        if (m_modelText[i].contains(m_linkPath))
        {
            modelText.push_back(m_modelText[i]);
            modelHelp.push_back(m_modelHelp[i]);
            modelName.push_back(m_modelName[i]);
            modelCanLink.push_back(m_modelCanLink[i]);
        }
    }
    m_modelText = modelText;
    m_modelName = modelName;
    m_modelHelp = modelHelp;
    m_modelCanLink = modelCanLink;

    endResetModel();
}

int	SofaLinkCompletionModel::rowCount(const QModelIndex & parent) const
{
    if (parent.isValid())
        return 0;

    return m_modelText.size();
}

QVariant SofaLinkCompletionModel::data(const QModelIndex &index, int role) const
{
    QString v = "";
    switch (role)
    {
    case CompletionRole:
        v = m_modelText[index.row()];
        v = v.remove(0, m_linkPath.size());
        break;
    case NameRole:
        v = m_modelName[index.row()];
        break;
    case HelpRole:
        v = m_modelHelp[index.row()];
        break;
    case CanLinkRole:
        return QVariant::fromValue(m_modelCanLink[index.row()]);
    default:
        break;
    }
    return QVariant::fromValue<QString>(v);
}

QHash<int, QByteArray> SofaLinkCompletionModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CompletionRole] = "completion";
    roles[NameRole] = "name";
    roles[HelpRole] = "help";
    roles[CanLinkRole] = "canLink";
    return roles;
}

}
