/*********************************************************************
Copyright 2019, Inria, CNRS, University of Lille

This file is part of runSofa2

runSofa2 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

runSofa2 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sofaqtquick. If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
/********************************************************************
 Contributors:
    - damien.marchal@univ-lille.fr
********************************************************************/

import QtQml.Models 2.2
import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import SofaApplication 1.0
import SofaSceneItemModel 1.0
import SofaSceneItemProxy 1.0
import SofaWidgets 1.0
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.4 as QQC1
import QtQuick.Controls.Styles 1.4 as QQCS1
import SofaComponent 1.0
import Sofa.Core.SofaData 1.0
import Sofa.Core.SofaNode 1.0
import Sofa.Core.SofaBase 1.0
import SofaBasics 1.0
import SofaColorScheme 1.0

Rectangle {
    id: root
    anchors.fill : parent
    color: SofaApplication.style.contentBackgroundColor
    enabled: SofaApplication.sofaScene ? SofaApplication.sofaScene.ready : false

    readonly property var searchBar: searchBar

    Item {

        //    /// Connect the scenegraph view so that it can be notified when the SofaApplication
        //    /// is trying to notify that the user is interested to get visual feedback on where componets are.
        Connections {
            target: SofaApplication
            function onSignalComponent(path) {
                var c = SofaApplication.sofaScene.get(path)
                if(c)
                {
                    var baseIndex = basemodel.getIndexFromBase(c)
                    var sceneIndex = sceneModel.mapFromSource(baseIndex)
                    treeView.expandAncestors(sceneIndex)
                    treeView.__listView.currentIndex = 0 // if not set to 0, adding nodes to the graph will only visualy select them
                    treeView.selection.setCurrentIndex(sceneIndex, ItemSelectionModel.ClearAndSelect)
                }
            }
        }
    }

    // search bar
    SofaSearchBar {
        id: searchBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        sofaScene: SofaApplication.sofaScene
        onSelectedItemChanged: {
            SofaApplication.selectedComponent = selectedItem
        }
    }

    TreeView {
        id : treeView
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
        alternatingRowColors: true


        rowDelegate: Rectangle {
            color: styleData.selected ? "#82878c" : styleData.alternate ? SofaApplication.style.alternateBackgroundColor : SofaApplication.style.contentBackgroundColor
        }

        headerDelegate: Rectangle {
            x: 5
            y: 2
            height: 30
            width: parent.width - 10
            color: SofaApplication.style.contentBackgroundColor
            property var pressed: styleData.pressed
            onPressedChanged: forceActiveFocus()
            RowLayout {
                id: headerLayout
                anchors.top: parent.top
                width: parent.width

                height: 22
                Label {
                    Layout.fillWidth: true
                    color: "black"
                    text: styleData.value
                }

                Label {
                    text: "Show only nodes: "
                }

                CheckBox {
                    id: nodesCheckBox
                    checked: false
                    onCheckedChanged: {
                        sceneModel.showOnlyNodes(checked)
                    }
                }
            }
            Rectangle {
                id: sep
                anchors.top: headerLayout.bottom
                y: 0
                x: 5
                width: parent.width - 10
                height: 1
                color: "#393939"
            }
            Rectangle {
                anchors.top: sep.bottom
                y: 1
                x: 5
                width: parent.width - 10
                height: 1
                color: "#959595"
            }
        }
        style: QQCS1.TreeViewStyle {
            headerDelegate: GBRect {
                color: "#757575"
                border.color: "black"
                borderWidth: 1
                borderGradient: Gradient {
                    GradientStop { position: 0.0; color: "#7a7a7a" }
                    GradientStop { position: 1.0; color: "#5c5c5c" }
                }
                height: 20
                width: textItem.implicitWidth
                Text {
                    id: textItem
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering
                }
            }

            branchDelegate: ColorImage {
                id: groupBoxArrow
                y: 1
                source: styleData.isExpanded ? "qrc:/icon/downArrow.png" : "qrc:/icon/rightArrow.png"
                width: 14
                height: 14
                color: "#393939"
            }
            backgroundColor: SofaApplication.style.contentBackgroundColor

            scrollBarBackground: GBRect {
                border.color: "#3f3f3f"
                radius: 6
                implicitWidth: 12
                implicitHeight: 12
                LinearGradient {
                    cached: true
                    source: parent
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    start: Qt.point(0, 0)
                    end: Qt.point(12, 0)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#565656" }
                        GradientStop { position: 1.0; color: "#5d5d5d" }
                    }
                }
                isHorizontal: true
                borderGradient: Gradient {
                    GradientStop { position: 0.0; color: "#444444" }
                    GradientStop { position: 1.0; color: "#515151" }
                }
            }

            corner: null
            scrollToClickedPosition: true
            transientScrollBars: false
            frame: Rectangle {
                color: "transparent"
            }

            handle: Item {
                implicitWidth: 12
                implicitHeight: 12
                GBRect {
                    radius: 6
                    anchors.fill: parent
                    border.color: "#3f3f3f"
                    LinearGradient {
                        cached: true
                        source: parent
                        anchors.left: parent.left
                        anchors.leftMargin: 1
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0

                        start: Qt.point(0, 0)
                        end: Qt.point(12, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#979797" }
                            GradientStop { position: 1.0; color: "#7b7b7b" }
                        }
                    }
                    isHorizontal: true
                    borderGradient: Gradient {
                        GradientStop { position: 0.0; color: "#444444" }
                        GradientStop { position: 1.0; color: "#515151" }
                    }

                }
            }
            incrementControl: Rectangle {
                visible: false
            }
            decrementControl: Rectangle {
                visible: false
            }
        }

        selection: ItemSelectionModel {
            id: selectionModel
            model: treeView.model
        }

        // Expands all ancestors of index
        function expandAncestors(index) {
            var idx = index.parent
            var old_idx = index
            while(idx && old_idx !== idx)
            {
                var srcIndex = sceneModel.mapToSource(idx)
                var theComponent = basemodel.getBaseFromIndex(srcIndex)
                if (theComponent === null) break;
                //console.error("Just expanded: " + theComponent.getPathName())
                // On dépile récursivement les parents jusqu'à root
                treeView.expand(idx)
                old_idx = idx
                idx = idx.parent
            }
        }
        // Collapses all ancestors of index
        function collapseAncestors(index) {
            var idx = index.parent
            var old_idx = index
            while(idx && old_idx !== idx)
            {
                var srcIndex = sceneModel.mapToSource(idx)
                var theComponent = basemodel.getBaseFromIndex(srcIndex)
                if (theComponent === null) break;
                // On dépile récursivement les parents jusqu'à root
                treeView.collapse(idx)
                old_idx = idx
                idx = idx.parent
            }
        }

        SofaSceneItemModel
        {
            id: basemodel
            sofaScene: SofaApplication.sofaScene;
        }

        model:  SofaSceneItemProxy
        {
            id: sceneModel
            model : basemodel

            onModelHasReset: {
                treeView.restoreNodeState()
            }

        }

        Settings {
            id: nodeSettings
            category: "Hierarchy"
            property var nodeState: ({})
        }

        function getExpandedState()
        {
            var nsArray = SofaApplication.nodeSettings.nodeState.split(';')
            for (var idx in nsArray)
            {
                if (nsArray[idx] !== "")
                {
                    var key = nsArray[idx].split(":")[0]
                    var value = nsArray[idx].split(":")[1]
                    nodeSettings.nodeState[key] = value
                }
            }
        }

        function restoreNodeState() {
//            treeView.selection.select(treeView.selection.currentIndex, selectionModel.Deselect)
            if (Object.keys(nodeSettings.nodeState).length === 0 && SofaApplication.nodeSettings.nodeState !== "") {
                getExpandedState()
            }
            for (var key in nodeSettings.nodeState) {
                if (nodeSettings.nodeState[key] === "1")
                {
                    var idx = null
                    idx = sceneModel.mapFromSource(basemodel.getIndexFromBase(SofaApplication.sofaScene.node(key)))
                    treeView.expand(idx)
                    expandAncestors(idx);
                }
            }
        }

        function storeExpandedState(index)
        {
            if (index.row === 0 && index.column === 0)
                /// Crash in mapToSource when passing index corresponding to root. dunno why..?
                return

            var srcIndex = sceneModel.mapToSource(index)
            var theComponent = basemodel.getBaseFromIndex(srcIndex)
            if (theComponent === null) return;
            nodeSettings.nodeState[theComponent.getPathName() !== "" ? theComponent.getPathName() : "/"] = treeView.isExpanded(index)
            var i = 0;
            SofaApplication.nodeSettings.nodeState = ""
            for (var key in nodeSettings.nodeState) {
                if (i !== 0)
                    SofaApplication.nodeSettings.nodeState += ";"
                SofaApplication.nodeSettings.nodeState += key + ":" + (nodeSettings.nodeState[key] ? "1" : "0")
                i++
            }
        }

        onExpanded: {
            storeExpandedState(currentIndex)
        }
        onCollapsed: {
            var srcIndex = sceneModel.mapToSource(currentIndex)
            var theComponent = basemodel.getBaseFromIndex(srcIndex)
            storeExpandedState(currentIndex)
        }

        itemDelegate: Rectangle {
            id: itemDelegateID

            Rectangle {
                id: insertInto
                anchors.fill: parent
                border.color: "lightsteelblue"
                border.width: 1
                color: "transparent"
                radius: 2
                visible: false
            }

            Rectangle {
                id: insertAfter
                anchors.bottom: parent.bottom
                implicitWidth: parent.width
                height: 3
                color: "transparent"
                visible: false
                y: -2
                Rectangle {
                    anchors.centerIn: parent
                    implicitWidth: parent.width
                    height: 1
                    color: "red"
                    visible: parent.visible
                }
            }


            property string origin: "Hierarchy"
            property bool multiparent : false
            property var renaming: false
            property string name : model && model.name ? model.name : ""
            property string typename : model && model.typename ? model.typename : ""
            property string shortname : model && model.shortname ? model.shortname : ""
            property bool isNode: model && model.isNode ? model.isNode : false
            property bool hasMultiParent : model && model.hasMultiParent ? model.hasMultiParent : false
            property bool isMultiParent : model && model.isMultiParent ? model.isMultiParent : false
            property bool hasMessage : model && testForMessage(styleData.index, styleData.isExpanded)
            property bool hasChildMessage : model && testForChildMessage(styleData.index, styleData.isExpanded)
            property string statusString: model && model.statusString
            property var index: styleData.index
            property var tmpParent

            Connections {
                target: treeView.selection
                function onCurrentIndexChanged(currentIndex) {

                    var srcIndex = sceneModel.mapToSource(currentIndex)
                    var treeViewComponent = basemodel.getBaseFromIndex(srcIndex)

                    srcIndex = sceneModel.mapToSource(itemDelegateID.index)
                    var component = basemodel.getBaseFromIndex(srcIndex)

                    if (!component || !treeViewComponent) return;
                    if (treeViewComponent.getPathName() === component.getPathName())
                    {
                        mouseArea.forceActiveFocus()
                    }
                }
            }

            color: "transparent"
            function getIconFromStatus(s)
            {
                if(s === "Undefined")
                    return "qrc:/icon/state_bubble_1.png"
                if(s === "Loading")
                    return "qrc:/icon/state_bubble_3.png"
                if(s === "Busy")
                    return "qrc:/icon/state_bubble_3.png"
                if(s === "Valid")
                    return "qrc:/icon/state_bubble_4.png"
                if(s === "Ready")
                    return "qrc:/icon/state_bubble_4.png"
                if(s === "Invalid")
                    return "qrc:/icon/state_bubble_5.png"

                return "qrc:/icon/state_bubble_1.png"
            }

            function testForChildMessage(index, isExpanded)
            {
                var srcIndex = sceneModel.mapToSource(index)
                var c = basemodel.getBaseFromIndex(srcIndex)

                if ( c===null )
                    return false

                if( !model.isNode )
                    return false

                return c.hasMessageInChild(c)
            }

            function testForMessage(index, isExpanded)
            {
                var srcIndex = sceneModel.mapToSource(index)
                var c = basemodel.getBaseFromIndex(srcIndex)

                if ( c===null )
                    return false
                return c.hasMessage();
            }

            function getFirstChildWithMessage(index)
            {
                var srcIndex = sceneModel.mapToSource(index)
                var c = basemodel.getBaseFromIndex(srcIndex)

                if ( c===null )
                    return null
                return c.getFirstChildWithMessage()
            }

            Item {
                id: icon
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 8
                implicitWidth: 12

                Rectangle {

                    id: colorIcon
                    implicitHeight: 8
                    implicitWidth: 8

                    radius: isNode ? implicitHeight*0.5 : 0
                    color: isNode ? "gray" : Qt.lighter("#FF" + Qt.md5(typename).slice(4, 10), 1.5)
                    border.width: 1
                    border.color: "black"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            sceneModel.flipComponentVisibility(styleData.index)
                        }
                    }

                    Image {
                        id: prefabIcon
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: 12
                        width: 12
                        visible:
                        {
                            var srcIndex = sceneModel.mapToSource(styleData.index)
                            var c = basemodel.getBaseFromIndex(srcIndex)
                            c!==null && isNode && c.isPrefab()
                        }
                        source: "qrc:/icon/ICON_PREFAB.png"
                        opacity: 1.0
                    }
                }
                Rectangle {
                    anchors.left: colorIcon.left
                    anchors.leftMargin: 4
                    visible: hasMultiParent || isMultiParent
                    implicitHeight: 8
                    implicitWidth: 8
                    radius: isNode ? implicitHeight*0.5 : 0
                    color: "gray"
                    opacity: 0.5
                    border.width: 1
                    border.color: "black"
                }
            }

            Component {
                id: textComponent
                Text {
                    id: rowText

                    color: model && model.isEnabled ? styleData.textColor : "darkgray"
                    font.italic: hasMultiParent
                    elide: Text.ElideRight
                    clip: true
                    text: {
                        if (isNode || typename == name)
                            return name
                        else if (name == shortname)
                            return name
                        else
                            return typename+" ("+name+")"
                    }
                }
            }

            Component {
                id: renamingTextComponent
                TextField {
                    id: renamingText
                    text: name
                    enabled: true
                    selectByMouse: true
                    function forceFocus() {
                        selectAll()
                        forceActiveFocus()
                    }
                    Component.onCompleted: {
                        forceFocus()
                    }
                    onEditingFinished: {
                        var srcIndex = sceneModel.mapToSource(index)
                        var c = basemodel.getBaseFromIndex(srcIndex)
                        if (c.rename(text))
                            renaming = false
                        else
                            forceFocus()
                    }
                }
            }
            Loader {
                id: textLoader
              // Explicitly set the size of the
              // Loader to the parent item's size
                anchors.left: icon.right
                anchors.right: parent.right
                anchors.rightMargin: 40
                sourceComponent: {
                    return renaming ? renamingTextComponent : textComponent
                }
            }


            Image {
                id: componentState
                anchors.verticalCenter: textLoader.verticalCenter
                anchors.right: parent.right
                height: 12
                width: 12
                visible: true
                source: getIconFromStatus(statusString)
                opacity: 0.75

            }
            SofaWindowComponentMessages { id: windowMessage }

            IconButton {
                /// This is the error button that shows when there is an error message on
                /// an object or a node
                id: childError
                hoverEnabled: true
                anchors.verticalCenter: textLoader.verticalCenter
                anchors.right: componentState.left
                height: 12
                width: 12
                enabled: hasMessage || (hasChildMessage && !styleData.isExpanded) || !root.enabled
                visible: hasMessage || (hasChildMessage && !styleData.isExpanded) || !root.enabled
                iconSource: "qrc:/icon/ICON_WARNING.png"
                useHoverOpacity: false
                layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: {
                                if (isNode) {
                                    if (hasChildMessage || !root.enabled)
                                        return childError.hovered || localError.hovered ? "red" : "darkred"
                                    else
                                        return childError.hovered || localError.hovered ? "#DDDDDD" : "#BBBBBB"
                                } else {
                                    if (hasMessage)
                                        return childError.hovered || localError.hovered ? "red" : "darkred"
                                    else
                                        return childError.hovered || localError.hovered ? "#DDDDDD" : "#BBBBBB"
                                }
                            }
                            onColorChanged: {
                                childError.iconSource = childError.iconSource
                            }
                        }
                }

                onClicked: {
                    if(isNode)
                    {
                        var c = getFirstChildWithMessage(index)
                        var idx = sceneModel.mapFromSource(basemodel.getIndexFromBase(c))
                        treeView.expandAncestors(idx)
                        SofaApplication.selectedComponent = c;
                        treeView.__listView.positionViewAtIndex(index, "EnsureVisible")

                        forceActiveFocus()
                        return
                    }

                    var srcIndex = sceneModel.mapToSource(index)
                    var c = basemodel.getBaseFromIndex(srcIndex)
                    var w = windowMessage.createObject(nodeMenu.parent,{
                                                   "parent" : nodeMenu.parent,
                                                   "sofaComponent": c});
                }
                z: 1
            }





            IconButton {
                /// Window that contains the object message. The windows is only created when the menu item
                /// is clicked

                id: localError
                hoverEnabled: true
                anchors.verticalCenter: textLoader.verticalCenter
                anchors.right: childError.left
                anchors.rightMargin: -6
                height: 12
                width: 12
                visible: (hasMessage || (hasChildMessage && !styleData.isExpanded)) && isNode
                iconSource: "qrc:/icon/ICON_WARNING.png"
                useHoverOpacity: false
                layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: {
                                if (hasMessage)
                                    return childError.hovered || localError.hovered ? "red" : "darkred"
                                else
                                    return childError.hovered || localError.hovered ? "#DDDDDD" : "#BBBBBB"
                            }
                            onColorChanged: {
                                childError.iconSource = childError.iconSource
                            }
                        }
                }
                enabled: hasMessage
                onClicked: {
                    var srcIndex = sceneModel.mapToSource(index)
                    var c = basemodel.getBaseFromIndex(srcIndex)
                    var w = windowMessage.createObject(nodeMenu.parent,{
                                                   "parent" : nodeMenu.parent,
                                                   "sofaComponent": c});

                }
                z: 1
            }

            SofaNodeMenu
            {
                id: nodeMenu
                model: sceneModel
                index: styleData.index
            }

            SofaObjectMenu
            {
                id: objectMenu
                model: sceneModel
                index: styleData.index
            }

            Item {
                id: dragItem
                property string origin: "Hierarchy"
                property SofaBase item
                property var dropInto: true
                property var dropBetween: true
                Drag.active: mouseArea.drag.active
                Drag.onActiveChanged: {
                    if (Drag.active) {
                        var srcIndex = sceneModel.mapToSource(index)
                        var theComponent = basemodel.getBaseFromIndex(srcIndex)
                        item = theComponent
                    }
                }

                Drag.dragType: Drag.Automatic
                Drag.supportedActions: Qt.CopyAction
                Drag.mimeData: {
                    "text/plain": "Copied text"
                }
            }

            ToolTip {
                text: typename
                description: "status: " + statusString
                visible: mouseArea.containsMouse
            }


            MouseArea {
                id: mouseArea

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                hoverEnabled: true


                drag.target: dragItem

                Keys.onDeletePressed: {
                    var srcIndex = sceneModel.mapToSource(styleData.index)
                    var parent = basemodel.getBaseFromIndex(srcIndex.parent);
                    var theComponent = basemodel.getBaseFromIndex(srcIndex)
                    if (theComponent.isNode())
                        parent.removeChild(theComponent);
                    else
                        parent.removeObject(theComponent);
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_F2)
                    {
                        print("renaming....")
                        renaming = true
                    }
                }

                onClicked:
                {
                    var srcIndex = sceneModel.mapToSource(styleData.index)
                    var theComponent = basemodel.getBaseFromIndex(srcIndex)
                    if(mouse.button === Qt.LeftButton) {
                        SofaApplication.selectedComponent = theComponent

                    } else if (mouse.button === Qt.RightButton) {
                        if(theComponent.isNode()) {
                            //                            nodeMenu.currentModelIndex = srcIndex
                            nodeMenu.activated = theComponent.getData("activated");
                            if(theComponent.hasLocations()===true)
                            {
                                nodeMenu.sourceLocation = theComponent.getSourceLocation()
                                nodeMenu.creationLocation = theComponent.getInstanciationLocation()
                            }
                            nodeMenu.nodeActivated = nodeMenu.activated.value;
                            var pos = SofaApplication.getIdealPopupPos(nodeMenu, mouseArea)
                            nodeMenu.x = mouseArea.mouseX + pos[0]
                            nodeMenu.y = mouseArea.mouseY + pos[1]
                            nodeMenu.open();
                        } else {
                            if(theComponent.hasLocations()===true)
                            {
                                objectMenu.sourceLocation = theComponent.getSourceLocation()
                                objectMenu.creationLocation = theComponent.getInstanciationLocation()
                            }
                            objectMenu.name = theComponent.getData("name");
                            pos = SofaApplication.getIdealPopupPos(objectMenu, mouseArea)
                            objectMenu.x = mouseArea.mouseX + pos[0]
                            objectMenu.y = mouseArea.mouseY + pos[1]
                            console.error(objectMenu.x + " " + objectMenu.y)
                            objectMenu.open()
                        }
                    }
                }


                DropArea {
                    id: dropArea
                    property SofaBase node: null
                    anchors.fill: parent
                    onEntered: {
                        var srcIndex = sceneModel.mapToSource(styleData.index)
                        var theComponent = basemodel.getBaseFromIndex(srcIndex)
                        if (isNode) node = theComponent
                        else node = theComponent.getFirstParent()
                    }
                    onExited: {
                        insertAfter.visible = false
                        insertInto.visible = false
                    }
                    onPositionChanged: {
                        var verticalsectionHeight = mouseArea.height / 3
                        if (drag.y < verticalsectionHeight * 2) {
                            insertAfter.visible = false
                            insertInto.visible = true
                        } else {
                            insertInto.visible = false
                            insertAfter.visible = true
                        }
                    }

                    function linkCommonDataFields(src, dest) {
                        for (var fname of src.getDataFields())
                        {
                            var sofaData = dest.findData(fname)
                            if (sofaData !== null)
                            {
                                var data = src.getData(sofaData.getName())
                                if (data !== null && data.isAutoLink())
                                {
                                    sofaData.setValue(data.value)
                                    sofaData.setParent(data)
                                }
                            }
                        }
                    }

                    function dropNodeIntoObject(src, dest) {
                        /// Dropping a node on an object creates links between compatible datafields
                        linkCommonDataFields(src, dest)
                    }

                    function dropNodeIntoNode(src, dest) {
                        var oldParent = src.getFirstParent()
                        if (!oldParent) {
                            console.error("Cannot drop root into child nodes")
                            return
                        }
                        if (oldParent.getPathName() !== dest.getPathName() && dest.getPathName() !== src.getPathName())
                            dest.moveChild(src, oldParent)
                    }

                    function dropObjectIntoNode(src, dest) {
                        dest.moveObject(src)
                    }

                    function dropObjectIntoObject(src, dest) {
                        if (src.getPathName() === dest.getPathName()) {
                            console.error("Cannot link datafields to themselves")
                            return;
                        }
                        linkCommonDataFields(src, dest)
                    }

                    function dropNodeAfterObject(src, dest) {
                        var newParent = dest.getFirstParent()
                        if (newParent.objects().last().getPathName() === dest.getPathName()) {
                            newParent.insertChild(src, 0)
                        } else
//                            dropNodeIntoNode(src, newParent)
                            return // can't insert node between components: nodes and components don't mix
                        var baseIndex = basemodel.getIndexFromBase(newParent)
                        var idx = sceneModel.mapFromSource(baseIndex)
                        if (treeView.isExpanded(idx)) {
                            treeView.collapse(idx)
                        }
                        treeView.expand(idx)

                    }

                    function dropNodeAfterNode(src, dest) {
                        var baseIndex = basemodel.getIndexFromBase(dest)
                        var idx = sceneModel.mapFromSource(baseIndex)

                        var newParent = null
                        if (treeView.isExpanded(idx)) {
                            newParent = dest
                            dest.insertChild(src, 0)
                        } else {
                            newParent = dest.getFirstParent()
                            dest.getFirstParent().insertNodeAfter(dest, src)
                        }

                        baseIndex = basemodel.getIndexFromBase(newParent)
                        idx = sceneModel.mapFromSource(baseIndex)
                        if (treeView.isExpanded(idx)) {
                            treeView.collapse(idx)
                        }
                        treeView.expand(idx)
                    }

                    function dropObjectAfterNode(src, dest) {
                        var baseIndex = basemodel.getIndexFromBase(dest)
                        var idx = sceneModel.mapFromSource(baseIndex)

                        if (treeView.isExpanded(idx))
                            dest.insertObject(src, 0)
                        else
//                            dest.getFirstParent().moveObject(src)
                            return // can't insert an object after a node: nodes and objects don't mix

                        baseIndex = basemodel.getIndexFromBase(dest)
                        idx = sceneModel.mapFromSource(baseIndex)
                        if (treeView.isExpanded(idx)) {
                            treeView.collapse(idx)
                        }
                        treeView.expand(idx)
                    }

                    function dropObjectAfterObject(src, dest) {
                        if (src === dest)
                            return
                        var newContext = dest.getFirstParent()
                        newContext.insertObjectAfter(dest, src)
                        var baseIndex = basemodel.getIndexFromBase(src.getFirstParent())
                        var idx = sceneModel.mapFromSource(baseIndex)
                        if (treeView.isExpanded(idx)) {
                            treeView.collapse(idx)
                        }
                        treeView.expand(idx)
                    }


                    function dropFromHierarchy(src) {
                        print("drop from Hierarchy: " + src.item.getName())
                        var source = src.item
                        SofaApplication.selectedComponent = src.item

                        var newIndex = styleData.index
                        newIndex = sceneModel.mapToSource(newIndex)
                        var dst = basemodel.getBaseFromIndex(newIndex)

                        if (insertAfter.visible) {
                            if (source.isNode() && dst.isNode())
                            {
                                dropNodeAfterNode(source, dst)
                                SofaApplication.selectedComponent = source
                            }
                            else if (source.isNode() && !dst.isNode())
                            {
                                dropNodeAfterObject(source, dst)
                                SofaApplication.selectedComponent = source
                            }
                            else if (!source.isNode() && dst.isNode())
                            {
                                dropObjectAfterNode(source, dst)
                                SofaApplication.selectedComponent = source
                                source.setName(source.getName())
                            }
                            else if (!source.isNode() && !dst.isNode())
                            {
                                dropObjectAfterObject(source, dst)
                                SofaApplication.selectedComponent = source
                                source.setName(source.getName())
                            }
                        }
                        else {
                            if (source.isNode() && dst.isNode())
                            {
                                dropNodeIntoNode(source, dst)
                                SofaApplication.selectedComponent = source
                            }
                            else if (source.isNode() && !dst.isNode())
                            {
                                dropNodeIntoObject(source, dst)
                                SofaApplication.selectedComponent = dst
                            }
                            else if (!source.isNode() && dst.isNode())
                            {
                                dropObjectIntoNode(source, dst)
                                SofaApplication.selectedComponent = source
                            }
                            else if (!source.isNode() && !dst.isNode())
                            {
                                dropObjectIntoObject(source, dst)
                                SofaApplication.selectedComponent = dst
                            }
                        }
                    }

                    function dropFromProjectView(src) {
                        if (src.asset.typeString === "Python prefab" && src.assetName === "") {
                            var menuComponent = Qt.createComponent("qrc:/SofaWidgets/SofaAssetMenu.qml")
                            var assetMenu = menuComponent.createObject(dropArea, {
                                                                           "asset": src.asset,
                                                                           "parentNode": node,
                                                                           "basemodel": basemodel,
                                                                           "sceneModel": sceneModel,
                                                                           "treeView": treeView,
                                                                           "selection": ItemSelectionModel.ClearAndSelect,
                                                                           "showLoadScene": true
                                                                       });
                            assetMenu.open()
                        }
                        else {
                            var assetNode = src.asset.create(node, src.assetName)
                            if (!assetNode)
                                return
                            SofaApplication.selectedComponent = assetNode
                        }
                        var baseIndex = basemodel.getIndexFromBase(SofaApplication.selectedComponent)
                        var sceneIndex = sceneModel.mapFromSource(baseIndex)

                        if (!treeView.isExpanded(sceneIndex))
                            treeView.expand(sceneIndex)
                    }

                    onDropped: {
                        if (drag.source.origin === "Hierarchy") {
                            dropFromHierarchy(drag.source)
                        }
                        else {
                            dropFromProjectView(drag.source)
                        }
                        insertAfter.visible = false
                        insertInto.visible = false
                    }
                }
            }
        }

        QQC1.TableViewColumn {
            title: (String(SofaApplication.sofaScene.source).slice(String(SofaApplication.sofaScene.source).lastIndexOf("/")+1))
            role: "name"
        }
    }

}
