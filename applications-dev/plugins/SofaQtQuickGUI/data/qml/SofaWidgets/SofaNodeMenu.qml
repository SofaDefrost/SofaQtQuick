import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.2
import SofaBasics 1.0
import SofaApplication 1.0
import SofaSceneListModel 1.0
import SofaComponent 1.0
import SofaWidgets 1.0
import Sofa.Core.SofaData 1.0
//import GraphView 1.0

Menu {
    id: nodeMenu

//    onVisibleChanged: {
//        SofaApplication.selectedComponent = getComponent()
//    }

    function parsePython(c)
    {
        c=c.replace("(","[")
        c=c.replace(")","]")
        c=c.replace(/'/g,'"')
        console.log("PARSE... " + c)
        return JSON.parse(c)
    }

    function getComponent() {
        return model.model.getBaseFromIndex(model.mapToSource(index))
    }
    function getParentComponent() {
        return model.model.getBaseFromIndex(model.mapToSource(index).parent)
    }

    property var model
    property var index

    property bool nodeActivated: true
    property SofaData activated: null
    property var sourceLocation : null
    property var creationLocation : null

    /// Window that contains the object message. The windows is only created when the menu item
    /// is clicked
    SofaWindowComponentMessages { id: windowMessage }

    /// Windows which contains the component creator helper widget with auto-search in
    /// the factory and other database.
    // PopupWindowCreateComponent { id: popupWindowCreateComponent }

    /// Shows a popup with the Data list view.
    MenuItem {
        text: "Show data..."
        onTriggered: {
            sofaDataListViewWindowComponent.createObject(nodeMenu.parent,
                                                         {"sofaScene": root.sofaScene,
                                                          "sofaComponent": getComponent()});
        }
    }

    MenuItem {
        enabled: true
        text: "Inspect connections.."
        onTriggered:
        {
            GraphView.showConnectedComponents(getComponent())
            GraphView.open()
        }
    }

    MenuItem {
        enabled: true
        text: "Show local connections.."
        onTriggered:
        {
            GraphView.rootNode = getComponent()
            GraphView.open()
        }
    }


    MenuItem {
        enabled: getComponent() && getComponent().hasMessage()
        text: "Show messages..."
        onTriggered: {
            /// Creates and display an help window object
            windowMessage.createObject(nodeMenu.parent,
                                       {"sofaComponent": getComponent()});
        }
    }

    MenuItem {
        /// todo(dmarchal 2018-15-06) : This should display the content of the description string
        /// provided by Sofa, classname, definition location, declaration location.
        text: "Infos (TODO)"
        onTriggered: {
            console.log("TODO")
        }
    }

    MenuSeparator {}
    MenuItem {
        enabled: creationLocation !== null && creationLocation.length !== 0
        text: "Go to instanciation..."
        onTriggered: {
            var location = parsePython(creationLocation)
            SofaApplication.openInEditor(location[0], location[1])
        }
    }

    MenuItem {
        enabled: sourceLocation !== null && sourceLocation.length !== 0
        text: "Go to implementation..."
        onTriggered: {
            var location = parsePython(sourceLocation)
            SofaApplication.openInEditor(location[0], location[1])
        }
    }


    MenuSeparator {}
    MenuItem {
        enabled: getComponent() && getComponent().getFirstParent() ? true : false
        text: nodeMenu.nodeActivated ? "Deactivate" : "Activate"
        onTriggered: {
            SofaApplication.selectedComponent = getComponent()

            getComponent().toggleActive(!nodeMenu.nodeActivated)
            if (!nodeMenu.nodeActivated == false)
                treeView.collapse(index)
            else
                treeView.expand(index)
            model.model.sofaScene = null
            model.model.sofaScene = SofaApplication.sofaScene
        }
    }

    MenuSeparator {}
    MenuItem {
        text: "Delete"
        enabled: getParentComponent()
        onTriggered: {
            var parent = getParentComponent();
            var item = getComponent();
            parent.removeChild(item);
        }
    }

    RenameMenu {
        id: renameMenu
        enabled: getParentComponent()
    }


    MenuItem {
        text: "Add child"
        onTriggered: {
            var p = getComponent()
            var childName = p.getNextName("NEWNODE")
            var created = p.addChild(childName)
            if(created){
                SofaApplication.selectedComponent = p.getChild(childName)
            }
        }
    }

    MenuItem {
        text: "Add sibling"
        onTriggered: {
            var p = getComponent().getFirstParent()
            var childName = p.getNextName("NEWNODE")
            var created = p.addChild(childName)
            if(created) {
                SofaApplication.selectedComponent = p.getChild(childName)
            }
        }
        enabled: getParentComponent()
    }

    MenuItem {
        id: addObjectEntry
        text: "Add object..."
        onTriggered: {
            var popupComponent = SofaDataWidgetFactory.getWidget("qrc:/SofaWidgets/PopupWindowCreateComponent.qml")
            var popup2 = popupComponent.createObject(nodeMenu.parent, {
                                                         "sofaNode": getComponent(),
                                                         "x" : mouseLoc.mouseX,
                                                         "y" : mouseLoc.mouseY
                                                     });
            popup2.open()
            popup2.forceActiveFocus()        }
        MouseArea
        {
            id: mouseLoc
            hoverEnabled: true                //< handle mouse hovering.
            anchors.fill : parent
            acceptedButtons: Qt.NoButton      //< forward mouse click.
            propagateComposedEvents: true     //< forward other event.
            z: 0
        }
    }


    MenuSeparator {}
    MenuItem {
        text: "Save as Prefab..."
        onTriggered: {
            var n = getComponent()
            SofaApplication.currentProject.createPrefab(n);
        }
    }

}
