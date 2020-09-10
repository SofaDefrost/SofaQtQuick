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

    title: "Default"
    Layout.fillWidth: true
    Layout.minimumHeight: implicitHeight

    property var sofaData: null
    onSofaDataChanged: {
        values = sofaData.value.split(" ")
    }
    Connections {
        target: sofaData
        function onValueChanged(val) {
            // Breaks binding loop
            if (val === root.values.join(' ') || val === undefined)
                return;
            console.log("onValueChanged: "+val)
            root.values = val.split(" ")

        }
    }
    property var values
    property bool updating: false
    onValuesChanged: {
        console.log("onValuesChanged: " + values.length)
        if (values.length < 27) return
        updating = true
        console.log("updating fields: " + values.join(' '))
        name_tf.text = root.title = values[0]
        diffuse_cbx.checked = values[2] === "0" ? false : true
        console.log("setting useDiffuse to " + values[2])
        diffuse_repeater.model = [values[3], values[4], values[5], values[6]]

        ambient_cbx.checked = values[8] === "0" ? false : true
        ambient_repeater.model = [values[9], values[10], values[11], values[12]]

        specular_cbx.checked = values[14] === "0" ? false : true
        specular_repeater.model = [values[15], values[16], values[17], values[18]]

        emissive_cbx.checked = values[20] === "0" ? false : true
        emissive_repeater.model = [values[21], values[22], values[23], values[24]]

        shininess_cbx.checked = values[26] === "0" ? false : true
        shininess_sb.value = values[27]
        updating = false
    }

    property var diffuse_model
    property var ambient_model
    property var specular_model
    property var emissive_model

    function setSofaValue() {
        if (!sofaData || updating) return
        var newValue = name_tf.text
                + " Diffuse " + (diffuse_cbx.checked ? 1 : 0) + " " + diffuse_model.join(' ')
                + " Ambient " + (ambient_cbx.checked ? 1 : 0) + " " + ambient_model.join(' ')
                + " Specular " + (specular_cbx.checked ? 1 : 0) + " " + specular_model.join(' ')
                + " Emissive " + (emissive_cbx.checked ? 1 : 0) + " " + emissive_model.join(' ')
                + " Shininess " + (shininess_cbx.checked ? 1 : 0) + " " + shininess_sb.value
        console.log("Setting new value: " + newValue)
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
                id: name_tf
                Layout.fillWidth: true
                onEditingFinished: {
                    setSofaValue()
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "diffuse: "
                Layout.preferredWidth: 55
            }
            CheckBox {
                id: diffuse_cbx
                onCheckedChanged: {
                    setSofaValue()
                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    id: diffuse_repeater
                    model: [0,0,0,0]
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: modelData
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        from: 0
                        to: 1
                        onValueChanged: {
                            diffuse_model = diffuse_repeater.model
                            diffuse_model[index] = value
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
                id: ambient_cbx
                onCheckedChanged: {
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    id: ambient_repeater
                    model: [0,0,0,0]
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: modelData
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        from: 0
                        to: 1
                        onValueChanged:  {
                            ambient_model = ambient_repeater.model
                            ambient_model[index] = value
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
                id: specular_cbx
                onCheckedChanged:  {
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    id: specular_repeater
                    model: [0,0,0,0]
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: modelData
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        from: 0
                        to: 1
                        onValueChanged:  {
                            specular_model = specular_repeater.model
                            specular_model[index] = value
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
                id: emissive_cbx
                onCheckedChanged:  {
                    setSofaValue()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Repeater {
                    id: emissive_repeater
                    model: [0,0,0,0]
                    delegate: SpinBox {
                        Layout.fillWidth: true
                        value: modelData
                        position: cornerPositions[index === 0 ? "Left" : index === 3 ? "Right" : "Middle"]
                        from: 0
                        to: 1
                        onValueChanged:  {
                            emissive_model = emissive_repeater.model
                            emissive_model[index] = value
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
                id: shininess_cbx
                onCheckedChanged:  {
                    setSofaValue()
                }
            }
            SpinBox {
                id: shininess_sb
                Layout.fillWidth: true
                from: 0
                to: 128

                onValueChanged:  {
                    setSofaValue()
                }
            }
        }
    }
}
