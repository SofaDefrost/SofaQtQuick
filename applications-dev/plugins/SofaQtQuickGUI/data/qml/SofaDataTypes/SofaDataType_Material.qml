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
import QtQuick.Layouts 1.12
import SofaBasics 1.0

GroupBox {
    id: root

    title: name
    Layout.fillWidth: true
    Layout.minimumHeight: implicitHeight
    property var sofaData: null

    property string text: undefined !== sofaData.value ? sofaData.value.toString() : ""

    onTextChanged: {
        var list = text.split(" ")
        console.log(text)
        name = list[0]
        useDiffuse = list[2]
        diffuse = [list[3], list[4], list[5], list[6]]

        useAmbient = list[8]
        ambient = [list[9], list[10], list[11], list[12]]

        useSpecular = list[14]
        specular = [list[15], list[16], list[17], list[18]]

        useEmissive = list[20]
        emissive = [list[21], list[22], list[23], list[24]]

        useShininess = list[26]
        shininess = list[27]
    }

    Binding {
        target: root.sofaData
        property: "value"
        value: root.text
        when: !sofaData.isReadOnly
    }

    property string name
    property string useDiffuse
    property string useAmbient
    property string useSpecular
    property string useEmissive
    property string useShininess

    property var diffuse
    property var ambient
    property var specular
    property var emissive
    property var shininess


    function setSofaValue() {
        var newValue = name
                + " Diffuse " + useDiffuse + " " + root.diffuse.join(' ')
                + " Ambient " + useAmbient + " " + root.ambient.join(' ')
                + " Specular " + useSpecular + " " + root.specular.join(' ')
                + " Emissive " + useEmissive + " " + root.emissive.join(' ')
                + " Shininess " + useShininess + " " + root.shininess
        sofaData.setValue(newValue)
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        Layout.fillHeight: true

        RowLayout {
            id: nameLayout
            Layout.fillWidth: true
            Label {
                text: "name: "
                Layout.preferredWidth: 55
            }
            TextField {
                Layout.fillWidth: true
                text: root.name
                onEditingFinished: {
                    root.name = text
                    setValue()
                }
            }
        }
        RowLayout {
            id: diffuseLayout
            Layout.fillWidth: true
            Label {
                text: "diffuse: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                checked: root.useDiffuse
                onCheckedChanged: {
                    root.useDiffuse = checked
                    setSofaValue()
                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: root.diffuse
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: root.diffuse[index]
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        onValueChanged: {
                            root.diffuse[index] = value
                            setSofaValue()
                        }
                    }
                }
            }
        }

        RowLayout {
            id: ambientLayout
            Layout.fillWidth: true
            Label {
                text: "ambient: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                checked: root.useAmbient
                onCheckedChanged: {
                    root.useAmbient = checked
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: root.ambient
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: root.ambient[index]
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        onValueChanged:  {
                            root.ambient[index] = value
                            setSofaValue()
                        }
                    }
                }
            }
        }

        RowLayout {
            id: specularLayout
            Layout.fillWidth: true
            Label {
                text: "specular: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                checked: root.useSpecular
                onCheckedChanged:  {
                    root.useSpecular = checked
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: root.specular
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: root.specular[index]
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        onValueChanged:  {
                            root.specular[index] = value
                            setSofaValue()
                        }
                    }
                }
            }
        }

        RowLayout {
            id: emissiveLayout
            Layout.fillWidth: true
            Label {
                text: "emissive: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                checked: root.useEmissive
                onCheckedChanged:  {
                    root.useEmissive = checked
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    model: root.emissive
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: root.emissive[index]
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        onValueChanged:  {
                            root.emissive[index] = value
                            setSofaValue()
                        }
                    }
                }
            }
        }
        RowLayout {
            id: shininessLayout
            Layout.fillWidth: true
            Label {
                text: "shininess: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                checked: root.useShininess
                onCheckedChanged:  {
                    root.useShininess = checked
                    setSofaValue()
                }
            }
            SpinBox {
                Layout.fillWidth: true
                value: root.shininess
                onValueChanged:  {
                    root.shininess = value
                    setSofaValue()
                }
            }
        }
    }
}
