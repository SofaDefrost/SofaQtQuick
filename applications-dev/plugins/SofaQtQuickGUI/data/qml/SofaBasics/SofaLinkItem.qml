import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0
import SofaBasics 1.0
import SofaLinkCompletionModel 1.0

/// Implement the widget for Links.
ColumnLayout {
    id: control

    property alias text: txtField.text
    property var sofaData: null
    property var sofaLink: null
    onSofaLinkChanged: {
        completionModel.sofaLink = sofaLink
    }
    onSofaDataChanged: {
        completionModel.sofaData = sofaData
    }

    property string parentLinkPath : getParentLinkPath()


    function getParentLinkPath() {
        if (sofaData)
            return sofaData.parent !== null ? sofaData.getParent().linkPath : ""
        else if (sofaLink) {
            return sofaLink.targetPath.replace("//", "/")
        }
    }

    function setCompletion(path)
    {
        txtField.text = path
        txtField.isLinkValid(path)
        if (listView.currentIndex >= completionModel.rowCount())
            listView.currentIndex = 0
        completionModel.linkPath = path
        txtField.forceActiveFocus()
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 0
    onActiveFocusChanged: {
        if (activeFocus)
            txtField.forceActiveFocus()
    }
    RowLayout {
        spacing: -1

        TextField {
            id: txtField
            position: breakLinkButton.visible ? cornerPositions["Left"] : cornerPositions["Single"]
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            placeholderText: sofaData ? "Link: @./path/component." + sofaData.name : sofaLink ? "Link: @/path/component" : ""
            placeholderTextColor: "gray"
            font.family: "Helvetica"
            font.weight: Font.Thin
            text: parentLinkPath
            width: parent.width
            clip: true
            borderColor: 0 === parentLinkPath.length && sofaData ? "red" : "#393939"
            Keys.forwardTo: [listView.currentItem, listView]

            onEditingFinished: {
                if (!listView.currentItem) {
                    if (!isLinkValid(txtField.text) && txtField.text !== "") {
                        txtField.text = ""
                        breakLinkButton.clicked()
                    }
                    txtField.borderColor = "#393939"
                    focus = false
                    return
                }

                if (listView.currentItem.text.endsWith(' (convert)')) {
                    sofaData.tryLinkingIncompatibleTypes(listView.currentItem.text.split(' ')[0])
                    return;
                }
                txtField.text = listView.currentItem.text
                setLinkIfValid(listView.currentItem.text)

                txtField.borderColor = "#393939"
                focus = false
                if (sofaData)
                    sofaData.parentChanged(sofaData.parent)
            }
            onTextEdited: {
                isLinkValid(text)
                if (listView.currentIndex >= completionModel.rowCount())
                    listView.currentIndex = 0
                completionModel.linkPath = text
            }

            function isLinkValid(value)
            {
                var ret = false
                if (sofaData) {
                    ret = sofaData.isLinkValid(value)
                    if (ret) {
                        txtField.borderColor = "lightgreen"
                        popup.close()
                    } else {
                        txtField.borderColor = "red"
                        if (!popup.opened)
                            popup.open()
                    }
                }
                else if (sofaLink) {
                    ret = sofaLink.isLinkValid(value)
                    if (!popup.opened)
                        popup.open()
                    txtField.borderColor = ret ? "lightgreen" : "red"
                }
                return ret
            }

            function setLinkIfValid(value) {
                if (isLinkValid(value)) {
                    return sofaData ? sofaData.setLink(value) : sofaLink.setLinkedPath(value)
                }
                return false
            }

        }
        Popup {
            id: popup
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            visible: txtField.activeFocus && completionModel.rowCount()
            padding: 0
            margins: 0
            implicitWidth: txtField.width
            implicitHeight: 150
            contentWidth: txtField.width - padding
            contentHeight: listView.implicitHeight < 20 ? 20 : listView.implicitHeight
            y: 20
            ScrollView {
                anchors.fill: parent

                ListView {
                    id: listView
                    visible: txtField.activeFocus
                    anchors.fill: parent
                    currentIndex: 0
                    keyNavigationEnabled: true
                    model: SofaLinkCompletionModel {
                        id: completionModel
                        isComponent: false
                        onModelReset: {
                            listView.implicitHeight = completionModel.rowCount() * 20
                            parent.contentHeight = completionModel.rowCount() * 20
                            parent.height = parent.contentHeight
                        }
                    }

                    function selectCurrentCompletion() {
                        txtField.text = listView.currentItem.text
                        if (txtField.isLinkValid(listView.currentItem.text)) {
                            console.log("valid linkPath")
                        } else {
                            console.log("invalid linkPath")
                            completionModel.linkPath = txtField.text
                            listView.currentIndex = 0;
                        }
                    }

                    Keys.onTabPressed: {
                        selectCurrentCompletion()
                    }

                    Keys.onRightPressed: {
                        selectCurrentCompletion()
                    }

                    Keys.onDownPressed: {
                        currentIndex++
                        if (currentIndex >= listView.rowCount)
                            currentIndex = listView.rowCount - 1
                    }


                    delegate: Rectangle {
                        id: delegateId
                        property Gradient highlightcolor: Gradient {
                            GradientStop { position: 0.0; color: "#7aa3e5" }
                            GradientStop { position: 1.0; color: "#5680c1" }
                        }
                        property Gradient nocolor: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                        property var view: listView
                        property alias text: entryText.text
                        width: popup.contentWidth
                        height: 20
                        gradient: view.currentIndex === index ? highlightcolor : nocolor
                        Text {
                            id: entryText
                            color: view.currentIndex === index ? "black" : itemMouseArea.containsMouse ? "lightgrey" : !canLink ? "gray" : "white"
                            anchors.verticalCenter: parent.verticalCenter
                            width: popup.contentWidth - x * 2
                            x: 10
                            text: {
                                var itemPath = "@" + completionModel.linkPath + completion
                                if (canLink)
                                    return itemPath
                                else return itemPath + " (convert)"
                            }
                            elide: Qt.ElideLeft
                            clip: true
                            font.strikeout: !canLink
                        }
                        ToolTip {
                            text: name
                            description: {
                                if (!canLink)
                                    return help + "\nRequires a Type conversion engine"
                                return help
                            }
                            visible: itemMouseArea.containsMouse
                            timeout: 2000
                        }
                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                view.currentIndex = index
                                txtField.forceActiveFocus()
                                txtField.text = "@"+entryText.text
                            }
                        }
                    }
                }
            }
        }
        Button {
            id: breakLinkButton
            visible: parentLinkPath.length !== 0
            onClicked: {
                // Break link
                if (sofaData)
                    sofaData.setParent(null)
                else {
                    sofaLink.setLinkedBase(null)
                    txtField.text = parentLinkPath
                }
            }
            Image {
                width: 11
                height: 11
                source: "qrc:/icon/breakLink.png"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }
            position: cornerPositions["Right"]
            ToolTip {
                text: "break link"
            }
        }

    }
}
