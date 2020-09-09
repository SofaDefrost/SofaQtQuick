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

import QtQuick 2.0
import QtQuick.Controls 2.4
import SofaBasics 1.0

TextField {
    text: "value"
}

//GroupBox {
//    id: root

//    title: name
//    anchors.fill: parent

//    property var sofaData: null

//    property string text: undefined !== sofaData.value ? sofaData.value.toString() : ""

//    onTextChanged: {
//        var list = text.split(" ")
//        name = list[0]
//        useDiffuse = list[2]
//        diffuse = [list[3], list[4], list[5], list[6]]

//        useAmbient = list[8]
//        ambient = [list[9], list[10], list[11], list[12]]

//        useSpecular = list[14]
//        specular = [list[15], list[16], list[17], list[18]]

//        useEmissive = list[20]
//        emissive = [list[21], list[22], list[23], list[24]]

//        useShininess = list[26]
//        shininess = list[27]

//        console.log("name " + name)
//        console.log("useDiffuse " + useDiffuse)
//        console.log("useSpecular " + useSpecular)
//        console.log("useEmissive " + useEmissive)
//        console.log("useShininess " + useShininess)
//        console.log("useAmbient " + useAmbient)
//        console.log("ambient " + ambient)
//        console.log("diffuse " + diffuse)
//        console.log("specular " + specular)
//        console.log("emissive " + emissive)
//        console.log("shininess " + shininess)

//    }
//    Binding {
//        target: root.sofaData
//        property: "value"
//        value: root.text
//        when: !sofaData.isReadOnly
//    }

//    property string name
//    property string useDiffuse
//    property string useAmbient
//    property string useSpecular
//    property string useEmissive
//    property string useShininess

//    property var diffuse
//    property var ambient
//    property var specular
//    property var emissive
//    property var shininess


//    ColumnLayout {
//        spacing: 0
//        anchors.fill: parent

////        RowLayout {
////            id: nameLayout
////            Layout.fillWidth: true
////            Label {
////                text: "name: "
////            }
////            TextField {
////                Layout.fillWidth: true
////                text: name
////            }
////        }
//        RowLayout {
//            id: diffuseLayout
//            Layout.fillWidth: true
//            Label {
//                text: "diffuse: "
//                Layout.preferredWidth: 55
//            }
//            CheckBox {
//                checked: useDiffuse
//            }

//            RowLayout {
//                Layout.fillWidth: true
//                spacing: 0
//                Repeater {
//                    model: diffuse
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: diffuse[index]
//                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
//                    }
//                }
//            }
//        }

//        RowLayout {
//            id: ambientLayout
//            Layout.fillWidth: true
//            Label {
//                text: "ambient: "
//                Layout.preferredWidth: 55
//            }
//            CheckBox {
//                checked: useAmbient
//            }

//            RowLayout {
//                Layout.fillWidth: true
//                spacing: 0
//                Repeater {
//                    model: ambient
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: ambient[index]
//                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
//                    }
//                }
//            }
//        }

//        RowLayout {
//            id: specularLayout
//            Layout.fillWidth: true
//            Label {
//                text: "specular: "
//                Layout.preferredWidth: 55
//            }
//            CheckBox {
//                checked: useSpecular
//            }

//            RowLayout {
//                Layout.fillWidth: true
//                spacing: 0
//                Repeater {
//                    model: specular
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: specular[index]
//                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
//                    }
//                }
//            }
//        }

//        RowLayout {
//            id: emissiveLayout
//            Layout.fillWidth: true
//            Label {
//                text: "emissive: "
//                Layout.preferredWidth: 55
//            }
//            CheckBox {
//                checked: useEmissive
//            }

//            RowLayout {
//                Layout.fillWidth: true
//                spacing: 0
//                Repeater {
//                    model: emissive
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: emissive[index]
//                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
//                    }
//                }
//            }
//        }
//        RowLayout {
//            id: shininessLayout
//            Layout.fillWidth: true
//            Label {
//                text: "shininess: "
//                Layout.preferredWidth: 55
//            }
//            CheckBox {
//                checked: useShininess
//            }
//            SpinBox {
//                Layout.fillWidth: true
//                value: shininess
//            }
//        }
//    }
//}
