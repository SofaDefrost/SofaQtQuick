import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import SofaBasics 1.0
import SofaApplication 1.0
import SofaSceneListModel 1.0
import SofaWidgets 1.0


Menu {
    id: nodeMenu

    function parsePython(c)
    {
        c=c.replace("(","[")
        c=c.replace(")","]")
        c=c.replace(/'/g,'"')
        return JSON.parse(c)
    }

    property var model: null;     ///< The model from which we can get the objects.
    property var currentIndex;    ///< The index in the model.
    property bool nodeActivated: true
    property QtObject sofaData: null
    property string sourceLocation : null
    property string creationLocation : null

    /// Window that contains the object message. The windows is only created when the menu item
    /// is clicked
    SofaWindowComponentMessages { id: windowMessage }

    /// Windows which contains the component creator helper widget with auto-search in
    /// the factory and other database.
    PopupWindowCreateComponent { id: popupWindowCreateComponent }

    MenuItem {
        text: "Add child"
        onTriggered: {
            var newnode = sofaScene.addNodeTo(model.getComponentFromIndex(currentIndex))
            if(newnode){
                SofaApplication.signalComponent(newnode.getPathName());
            }
        }
    }

    MenuItem {
        text: "Add sibling"
        onTriggered: {
            var newnode = sofaScene.addNodeTo(model.getComponentFromIndex(currentIndex).parent())
            if(newnode){
                SofaApplication.signalComponent(newnode.getPathName());
            }
        }
    }

    MenuItem {
        /// todo(dmarchal 2018-15-06) : Add a component from the factory.
        text: "Add component (TODO)"
        onTriggered: {
            popupWindowCreateComponent.createObject(SofaApplication,
                                                    {"sofaComponent": model.getComponentFromIndex(currentIndex)});
        }
    }

    /// Shows a popup with the Data list view.
    MenuItem {
        text: "Data"
        onTriggered: {
            sofaDataListViewWindowComponent.createObject(SofaApplication,
                                                         {"sofaScene": root.sofaScene,
                                                          "sofaComponent": model.getComponentFromIndex(currentIndex)});
        }
    }

    MenuItem {
        text: "Messages"
        onTriggered: {
            /// Creates and display an help window object
            windowMessage.createObject(SofaApplication,
                                       {"sofaComponent": model.getComponentFromIndex(currentIndex)});
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
        text: "Go to scene (TODO)"
        onTriggered: {
            console.trace()
            var location = parsePython(creationLocation)
            SofaApplication.openInEditor(location[0], location[1])
        }
    }

    MenuItem {
        enabled: sourceLocation !== null && sourceLocation.length !== 0
        text: "Go to implementation (TODO)"
        onTriggered: {
            var location = parsePython(sourceLocation)
            SofaApplication.openInEditor(location[0], location[1])
        }
    }



    MenuSeparator {}
    MenuItem {
        enabled: (multiparent)? firstparent : true
        text: nodeMenu.nodeActivated ? "Deactivate" : "Activate"
        onTriggered: listView.model.setDisabled(index, nodeMenu.nodeActivated);
    }

    MenuSeparator {}
    MenuItem {
        text: "Delete"
        onTriggered: {
            var currentRow = listView.model.computeItemRow(listView.currentIndex);
            sofaScene.removeComponent(model.getComponentById(index));
            listView.updateCurrentIndex(listView.model.computeModelRow(currentRow));
        }
    }



}
