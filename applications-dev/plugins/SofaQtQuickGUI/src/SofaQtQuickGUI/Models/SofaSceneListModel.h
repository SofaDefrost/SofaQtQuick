/*
Copyright 2015, Anatoscope

This file is part of sofaqtquick.

sofaqtquick is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sofaqtquick is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sofaqtquick. If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef SOFASCENELISTMODEL_H
#define SOFASCENELISTMODEL_H

#include <QAbstractListModel>
#include <QQmlParserStatus>

#include <sofa/simulation/MutationListener.h>

#include <SofaQtQuickGUI/config.h>
#include <SofaQtQuickGUI/SofaBaseScene.h>

namespace sofaqtquick
{

/// \class A Model of the sofa scene graph allowing us to show the graph in a ListView
/// The model is not implementing any visualization feature like collapsing or hidding
/// some information. Those have to be implemented by in an external proxying model.
class SOFA_SOFAQTQUICKGUI_API SofaSceneListModel : public QAbstractListModel, private sofa::simulation::MutationListener
{
    Q_OBJECT

public:
    SofaSceneListModel(QObject* parent = 0);
    ~SofaSceneListModel();

    Q_INVOKABLE void update();

public slots:
    void clear();

public:
    Q_PROPERTY(sofaqtquick::SofaBaseScene* sofaScene READ sofaScene WRITE setSofaScene NOTIFY sofaSceneChanged)

public:
    SofaBaseScene* sofaScene() const		{return mySofaScene;}
    void setSofaScene(SofaBaseScene* newScene);

protected:
    Q_INVOKABLE int computeModelRow(int itemIndex) const;
    Q_INVOKABLE int computeItemRow(int modelIndex) const;
    int computeItemRow(const QModelIndex& index) const;
    int	rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariant get(int row) const;

    [[deprecated("This function is replaced with getDataByID")]]
    Q_INVOKABLE sofa::qtquick::SofaComponent* getComponentById(int row) const;

    [[deprecated("This function is replaced with getDataByID")]]
    Q_INVOKABLE int getComponentId(sofa::qtquick::SofaComponent*) const;

    [[deprecated("This function is replaced with getDataByID")]]
    Q_INVOKABLE sofaqtquick::bindings::SofaBase* getBaseById(int row) const;

    Q_INVOKABLE QList<int> computeFilteredRows(const QString& filter) const;

    void handleSceneChange(SofaBaseScene* newScene);

signals:
    void sofaSceneChanged(sofaqtquick::SofaBaseScene* newScene);

protected:

    /// The following function are inhereted from MutationLister
    virtual void onBeginAddChild(sofa::simulation::Node* parent, sofa::simulation::Node* child) override;
    virtual void onEndRemoveChild(sofa::simulation::Node* parent, sofa::simulation::Node* child) override;
    virtual void onBeginAddObject(sofa::simulation::Node* parent, sofa::core::objectmodel::BaseObject* object) override;
    virtual void onEndRemoveObject(sofa::simulation::Node* parent, sofa::core::objectmodel::BaseObject* object)override;


private:
    enum {
        NameRole = Qt::UserRole + 1,
        MultiParentRole,
        FirstParentRole,
        DepthRole,
        TypeRole,
        IsNodeRole
    };

    struct Item
    {
        Item() :
            parent(0),
            children(0),
            multiparent(false),
            firstparent(true),
            depth(0),
            base(0),
            object(0),
            node(0)
        {

        }

        Item*                                   parent;
        QVector<Item*>                          children;
        bool                                    multiparent;
        bool                                    firstparent;
        int                                     depth;

        sofa::core::objectmodel::Base*          base;
        sofa::core::objectmodel::BaseObject*    object;
        sofa::core::objectmodel::BaseNode*      node;
    };

    unsigned int countChildrenOf(const Item& a) ;
    Item buildNodeItem(Item* parent, sofa::core::objectmodel::BaseNode* node) const;
    Item buildObjectItem(Item* parent, sofa::core::objectmodel::BaseObject* object) const;

private:
    bool isAncestor(Item* ancestor, Item* child);

private:
    QList<Item>                     myItems;
    SofaBaseScene*                      mySofaScene;

};

}  // namespace sofaqtquick

#endif // SOFASCENELISTMODEL_H
