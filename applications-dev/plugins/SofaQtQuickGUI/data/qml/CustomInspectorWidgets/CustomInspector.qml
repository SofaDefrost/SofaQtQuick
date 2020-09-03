import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import SofaApplication 1.0
import SofaBasics 1.0
import SofaLinkCompletionModel 1.0


ColumnLayout {
    id: root
    spacing: 10
    property var component: SofaApplication.selectedComponent

    property var dropGroup: ""
    property var dropItem: null
    property var showAll: true
    property var dataDict: {"Base": ["name", "componentState", "printLog"]}
    onDataDictChanged: {
        groupRepeater.model = Object.keys(dataDict).length
    }
    property var linkList: []
    property var infosDict: {"class":component.getClassName(), "name": component.getName()}
    property var labelWidth: 1

    Repeater {
        id: groupRepeater
        model: Object.keys(dataDict).length

        GroupBox {
            id: dataGroup
            title: Object.keys(dataDict)[index]
            Layout.fillWidth: true

            function groupOnEntered(drag) {
                dropGroup = dataGroup.title
                dropItem = drag.source.item
            }
            function groupOnExited(drag) {
                dropGroup = ""
                dropItem = null
            }
            function groupOnDropped(drag) {
                if (drag.source.item.getPathName() === SofaApplication.selectedComponent.getPathName()) {
                    console.error("Cannot link datafields to themselves")
                    return;
                }

                for (var idx in SofaApplication.selectedComponent.getDataFields())
                {
                    var fieldName = SofaApplication.selectedComponent.getDataFields()[idx]
                    var data = dropItem.findData(fieldName)
                    if (data !== null && SofaApplication.selectedComponent.getData(fieldName).isAutoLink()) {
                        if (SofaApplication.selectedComponent.getData(fieldName).getGroup().toString() === dropGroup.toString()) {
                            SofaApplication.selectedComponent.getData(fieldName).setValue(data.value)
                            SofaApplication.selectedComponent.getData(fieldName).setParent(data)
                        }
                    }
                }
                dropGroup = ""
                dropItem = null
                SofaApplication.selectedComponent = SofaApplication.selectedComponent
            }

            ColumnLayout {
                id: groupLayout
                spacing: 1
                anchors.fill: parent

                MouseArea {
                    id: mGroupArea
                    width:  groupLayout.width
                    height: groupLayout.height
                    hoverEnabled: true


                    DropArea {
                        id: dropGroupArea
                        keys: ["text/plain"]
                        anchors.fill: parent
                        onEntered: {
                            groupOnEntered(drag)
                        }
                        onExited: {
                            groupOnExited(drag)
                        }

                        onDropped: {
                            groupOnDropped(drag)
                        }
                    }
                }
                Repeater {
                    id: dataRepeater
                    model: dataDict[Object.keys(dataDict)[index]]
                    Layout.fillWidth: true
                    RowLayout {
                        id: sofaDataLayout
                        property var sofaData: modelData ? component.getData(modelData) : null
                        Layout.fillWidth: true

                        Label {
                            Layout.minimumWidth: root.labelWidth
                            Layout.maximumWidth: root.labelWidth

                            text:  modelData
                            color: sofaDataLayout.sofaData.properties.required && !sofaDataLayout.sofaData.properties.set ? "red" : "black"
                            elide: Text.ElideRight

                            Rectangle {
                                id: dataFrame
                                color: "transparent"
                                border.color: "red"
                                border.width: 1
                                anchors.fill: parent
                                visible: {
                                    if (dropGroup === dataGroup.title || dropGroup == "all")
                                    {
                                        if (dropItem && dropItem.findData(modelData))
                                            return true
                                    }
                                    return false
                                }
                            }

                            ToolTip {
                                text: sofaDataLayout.sofaData.getName()
                                description: sofaDataLayout.sofaData.getHelp()
                                visible: marea.containsMouse
                            }

                            MouseArea {
                                id: marea
                                anchors.fill: parent
                                hoverEnabled: true
                                onPressed: forceActiveFocus()

                                DropArea {
                                    id: dropArea
                                    keys: ["text/plain"]
                                    anchors.fill: parent
                                    onEntered: {
                                        if (drag.source.item.getPathName() === SofaApplication.selectedComponent.getPathName()) {
                                            return;
                                        }
                                        var data = drag.source.item.findData(sofaData.getName())
                                        if (sofaData.getValueType() === "PrefabLink" || data !== null) {
                                            dataFrame.visible = true
                                        }
                                    }
                                    onExited: {
                                        dataFrame.visible = false
                                    }

                                    onDropped: {
                                        if (sofaData.getValueType() === "PrefabLink") {
                                            sofaData.value = "@" + drag.source.item.getPathName()
                                            return;
                                        }

                                        if (drag.source.item.getPathName() === SofaApplication.selectedComponent.getPathName()) {
                                            console.error("Cannot link datafields to themselves")
                                            return;
                                        }
                                        var data = drag.source.item.findData(sofaData.getName())
                                        if (data !== null) {
                                            sofaData.setValue(data.value)
                                            sofaData.setParent(data)
                                        }
                                        dataFrame.visible = false
                                    }
                                }
                            }
                            Component.onCompleted: {
                                if (width > root.labelWidth)
                                    root.labelWidth = 150
                            }
                        }
                        Loader {
                            id: dataItemLoader

                            Layout.fillWidth: true
                            source: linkButton.checked
                                    ? "qrc:/SofaBasics/SofaLinkItem.qml"
                                    : "qrc:/SofaDataTypes/SofaDataType_" + sofaDataLayout.sofaData.properties.type + ".qml"
                            onLoaded: {
                                item.sofaData = Qt.binding(function(){return sofaDataLayout.sofaData})
                            }
                            DropArea {
                                id: dropArea2
                                anchors.fill: parent

                                onDropped: {
                                    if (sofaData.getValueType() === "PrefabLink") {
                                        sofaData.value = "@" + drag.source.item.getPathName()
                                        return;
                                    }
                                    var data = drag.source.item.getData(sofaData.getName())
                                    if (drag.source.item.getPathName() === SofaApplication.selectedComponent.getPathName()) {
                                        console.error("Cannot link datafields to themselves")
                                        return;
                                    }

                                    if (data !== null) {
                                        sofaData.setValue(data.value)
                                        sofaData.setParent(data)
                                    }
                                }
                            }


                        }
                        Button {
                            id: linkButton
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                            anchors.margins: 3
                            checkable: true
                            checked: sofaDataLayout.sofaData ? null !== sofaDataLayout.sofaData.parent : false
                            onCheckedChanged: {
                                if (dataItemLoader.item)
                                    dataItemLoader.item.forceActiveFocus()
                            }

                            activeFocusOnTab: false
                            ToolTip {
                                text: "Show / Hide link to parent"
                            }

                            Image {
                                id: linkButtonImage
                                anchors.fill: parent
                                source: sofaDataLayout.sofaData.parent ? "qrc:/icon/validLink.png" : "qrc:/icon/invalidLink.png"
                            }
                        }
                    }
                }
            }
        }
    }
    GroupBox {
        title: "Links"
        visible: linkList.length > 0
        ColumnLayout {
            anchors.fill: parent
            spacing: 1
            Repeater {
                model: linkList
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: modelData
                        Layout.minimumWidth: root.labelWidth
                        Component.onCompleted: {
                            if (width > root.labelWidth)
                                root.labelWidth = 150
                        }
                        color: "black"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: forceActiveFocus()
                        }
                        elide: Text.ElideRight
                    }
                    TextField {
                        id: txtField
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        readOnly: false

                        text: component.findLink(modelData).getLinkedPath().trim()
                        DropArea {
                            id: link_dropArea1
                            anchors.fill: parent

                            onDropped: {
                                component.findLink(modelData).setLinkedBase(drag.source.item)
                                txtField.text = Qt.binding(function(){ return component.findLink(modelData).getLinkedPath().trim() })
                            }
                        }
                        onEditingFinished: {
                            component.findLink(modelData).setLinkedPath(text)
                            focus = false
                        }
                        onTextEdited: {
                            component.findLink(modelData).setLinkedPath(text)
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        width: 14
                        MouseArea {
                            anchors.fill: parent
                            onPressed: forceActiveFocus()
                        }
                    }
                }
            }
        }
    }
    GroupBox {
        title: "Infos"
        ColumnLayout {
            id: infosLayout
            property var labelWidth: 0

            Repeater {
                model: Object.keys(infosDict)
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        Layout.minimumWidth: infosLayout.labelWidth
                        elide: Text.ElideRight
                        text: modelData + " :"
                        color: "black"
                        Component.onCompleted: {
                            if (width > infosLayout.labelWidth)
                                infosLayout.labelWidth = 150
                        }
                        MouseArea {
                            anchors.fill: parent
                            onPressed: forceActiveFocus()
                        }
                    }
                    Label {
                        text: infosDict[Object.keys(infosDict)[index]]
                        color: "#333333"
                        elide: Qt.ElideRight
                        clip: true
                        MouseArea {
                            anchors.fill: parent
                            onPressed: forceActiveFocus()
                        }
                    }
                }
            }
        }

    }
}
