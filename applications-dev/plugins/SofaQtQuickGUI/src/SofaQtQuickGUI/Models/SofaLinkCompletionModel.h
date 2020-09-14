#pragma once

#include <QAbstractListModel>
#include <SofaQtQuickGUI/Bindings/SofaData.h>
#include <SofaQtQuickGUI/Bindings/SofaLink.h>

namespace sofa::core::objectmodel {
class BaseNode;
}

namespace sofaqtquick {


class SofaLinkCompletionModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum DataCompletionRoles {
        CornerRole = Qt::UserRole + 1,
        CompletionRole,
        NameRole,
        HelpRole,
        CanLinkRole,
    };
    SofaLinkCompletionModel(QObject* parent = nullptr)
        : QAbstractListModel(parent),
          m_sofaData(nullptr),
          m_sofaLink(nullptr),
          m_linkPath("")
    {}

    Q_PROPERTY(sofaqtquick::bindings::_sofalink_::SofaLink* sofaLink READ sofaLink WRITE setSofaLink NOTIFY sofaLinkChanged);
    Q_PROPERTY(sofaqtquick::bindings::_sofadata_::SofaData* sofaData READ sofaData WRITE setSofaData NOTIFY sofaDataChanged);
    Q_PROPERTY(QString linkPath READ getLinkPath WRITE setLinkPath NOTIFY linkPathChanged)
    Q_PROPERTY(bool isComponent READ isComponent WRITE setIsComponent NOTIFY isComponentChanged)

    inline bool isComponent() const { return m_isComponent; }
    void setIsComponent(bool isComponent) { m_isComponent = isComponent; }


    inline sofaqtquick::bindings::SofaData* sofaData() const { return m_sofaData; }
    void setSofaData(sofaqtquick::bindings::SofaData* newSofaData);

    inline sofaqtquick::bindings::_sofalink_::SofaLink* sofaLink() const { return m_sofaLink; }
    void setSofaLink(sofaqtquick::bindings::_sofalink_::SofaLink* newSofaLink);

    inline QString getLinkPath() const { return m_linkPath; }
    void setLinkPath(QString newlinkPath);

signals:
    void sofaDataChanged(sofaqtquick::bindings::SofaData* newSofaData) const;
    void sofaLinkChanged(sofaqtquick::bindings::_sofalink_::SofaLink* newSofaLink) const;
    void linkPathChanged(QString newlinkPath) const;
    void isComponentChanged(bool isComponent) const;

protected:
    int	rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

private:
    sofaqtquick::bindings::_sofadata_::SofaData* m_sofaData;
    sofaqtquick::bindings::_sofalink_::SofaLink* m_sofaLink;
    QString m_linkPath;
    bool m_isComponent;

    QStringList m_modelText;
    QStringList m_modelName;
    QStringList m_modelHelp;
    QList<bool> m_modelCanLink;



    sofa::core::objectmodel::BaseNode* m_relativeRoot;
    sofa::core::objectmodel::BaseNode* m_absoluteRoot;


    bool isValid(const QString& path) const;
    sofa::core::objectmodel::Base* getLastValidObject(QString& );
    void updateModel();

};

}  // namespace sofaqtquick
