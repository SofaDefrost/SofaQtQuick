import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import SofaApplication 1.0
import SofaSceneListModel 1.0
import SofaComponent 1.0
import Sofa.Core.SofaData 1.0
import SofaWidgets 1.0
import SofaBasics 1.0
//import SofaViews 1.0

Menu {

    function parsePython(c)
    {
        c=c.replace("(","[")
        c=c.replace(")","]")
        c=c.replace(/'/g,'"')
        console.log("PARSE... " + c)
        return JSON.parse(c)
    }

    /// Window that contains the object message. The windows is only created when the menu item
    /// is clicked
    SofaWindowComponentMessages { id: windowMessage }

    id: objectMenu

    property var model: null;
    property var index;
    property SofaData name: null
    property var sourceLocation : null
    property var creationLocation : null

    function getComponent() {
        return model.model.getBaseFromIndex(model.mapToSource(index))
    }

    function getParentComponent() {
        return model.model.getBaseFromIndex(model.mapToSource(index).parent)
    }
//    onVisibleChanged: {
////        SofaApplication.selectedComponent = getComponent()
//    }

    MenuItem {
        enabled: true
        text: "Show connections.."
        onTriggered:
        {
            var node = getComponent()
            GraphView.showConnectedComponents(node)
            GraphView.open()
        }
    }


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
        text: "Documentation ..."
        onTriggered: {
            var dirtyHack = {
                "DefaultAnimationLoop" : "https://www.sofa-framework.org/community/doc/using-sofa/components/animationloop/defaultanimationloop/",
                "FreeMotionAnimationLoop" : "https://www.sofa-framework.org/community/doc/using-sofa/components/animationloop/freemotionanimationloop/",
                "UniformMass" : "https://www.sofa-framework.org/community/doc/using-sofa/components/masses/uniformmass/",
                "DiagonalMass" : "https://www.sofa-framework.org/community/doc/using-sofa/components/masses/diagonalmass/",
                "EulerExplicitSolver" : "https://www.sofa-framework.org/community/doc/using-sofa/components/integrationscheme/eulerexplicitsolver/",
                "EulerImplicitSolver" : "https://www.sofa-framework.org/community/doc/using-sofa/components/integrationscheme/eulerimplicitsolver/",
                "CGLinearSolver" : "https://www.sofa-framework.org/community/doc/using-sofa/components/linearsolver/cglinearsolver/",
                "SparseLDLSolver" : "https://www.sofa-framework.org/community/doc/using-sofa/components/linearsolver/sparseldlsolver/"
            }
            var base = getComponent()
            var className = base.getClassName()
            var url = 'https://sofacomponents.readthedocs.io/en/latest/search.html?q='+className+'&check_keywords=yes&area=default'
            if( className in dirtyHack )
                url = dirtyHack[className]
            var o = windowGraph.createObject(root, {
                                                     "source": "qrc:///SofaViews/WebBrowserView.qml",
                                                     "title" : "Sofa Ressources Repository",
                                                     "url": url,
                                                     "width" : 800,
                                                     "height": 600,
                                                 }
                                             );
        }

        Component {
            id: windowGraph

            Window {
                property url source
                property url url

                id: window
                width: 600
                height: 400
                modality: Qt.NonModal
                flags: Qt.Tool | Qt.WindowStaysOnTopHint | Qt.CustomizeWindowHint | Qt.WindowSystemMenuHint |Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint
                visible: true
                color: SofaApplication.style.contentBackgroundColor

                Loader {
                    id: loader
                    anchors.fill: parent
                    source: window.source
                    onLoaded: { item.url = url }
                }
            }
        }
    }



    MenuSeparator {}
    MenuItem {
        text: {
            "Delete object"
        }
        onTriggered: {
            var parent = getParentComponent();
            var item = getComponent();
            parent.removeObject(item);
        }
    }

    MenuItem {
        text: "Add node..."
        onTriggered: {
            var p = getComponent().getFirstParent()
            var childName = p.getNextName("NEWNODE")
            var created = p.addChild(childName)
            if(created){
                SofaApplication.selectedComponent = p.getChild(childName)
            }

        }
    }

    MenuItem {
        id: addObjectEntry
        text: "Add object..."
        onTriggered: {
            var popupComponent = Qt.createComponent("qrc:/SofaWidgets/PopupWindowCreateComponent.qml")
            var popup2 =
                    popupComponent.createObject(objectMenu.parent,
                                                {
                                                    "sofaNode": getComponent().getFirstParent(),
                                                    "x" : mouseLoc.mouseX,
                                                    "y" : mouseLoc.mouseY
                                                });
            popup2.open()
            popup2.forceActiveFocus()
        }
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

    RenameMenu {
        id: renameMenu
    }
}
