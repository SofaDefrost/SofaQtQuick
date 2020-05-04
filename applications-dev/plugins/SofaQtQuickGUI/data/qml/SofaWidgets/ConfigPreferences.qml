import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4
import SofaBasics 1.0

TabView {
    id: root
    Tab {
        title: "General"
        anchors.margins: 10
        GroupBox {
            title: "Location:"
            RowLayout {
                anchors.fill: parent
                Rectangle {
                    id: plop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    border.color: "black"
                    color: "#2a2b2c"
                    ListView {
                        id: listview
                        anchors.fill: parent

                        anchors.margins: 1
                        currentIndex: 0
                        model: ListModel {
                            ListElement {
                                path: "%ProjectDir%/config/"
                            }
                            ListElement {
                                path: "~/.config/runSofa2/"
                            }
                            ListElement {
                                path: "%SOFA_INSTALL_DIR%/share/runSofa2/config/"
                            }
                        }
                        delegate: Rectangle {
                            id: rect
                            color: index === listview.currentIndex ? "#26525d" : "#2a2b2c"
                            width: parent.width
                            height: 20
                            Text {
                                x: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: path
                                font.bold: true
                                color: "#ABABAB"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    listview.currentIndex = index

                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 100
                    spacing: 2
                    Button {
                        implicitWidth: parent.width
                        text: "Add"
                    }
                    Button {
                        implicitWidth: parent.width
                        text: "Remove"
                    }
                    Rectangle {
                        width: 1
                        height: 10
                        color: "transparent"
                    }

                    Button {
                        implicitWidth: parent.width
                        text: "Move up"
                    }
                    Button {
                        implicitWidth: parent.width
                        text: "Move down"
                    }
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: "transparent"
                    }
                    Button {
                        implicitWidth: parent.width
                        text: "Reset defaults"
                    }

                }
            }
        }
    }
}
