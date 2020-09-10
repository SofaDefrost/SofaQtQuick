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
        dataValueConnection.onValueChanged(sofaData.value)
    }

    Connections {
        id: dataValueConnection
        target: sofaData
        function onValueChanged(value) {
            // Breaks binding loop
            if (value === undefined)
                return;
            updating = true
            name_tf.text = root.title = value["name"]

            diffuse_cbx.checked = value["useDiffuse"]
            diffuse_r.value = value["diffuse"][0]
            diffuse_g.value = value["diffuse"][1]
            diffuse_b.value = value["diffuse"][2]
            diffuse_a.value = value["diffuse"][3]

            ambient_cbx.checked = value["useAmbient"]
            ambient_r.value = value["ambient"][0]
            ambient_g.value = value["ambient"][1]
            ambient_b.value = value["ambient"][2]
            ambient_a.value = value["ambient"][3]

            specular_cbx.checked = value["useSpecular"]
            specular_r.value = value["specular"][0]
            specular_g.value = value["specular"][1]
            specular_b.value = value["specular"][2]
            specular_a.value = value["specular"][3]

            emissive_cbx.checked = value["useEmissive"]
            emissive_r.value = value["emissive"][0]
            emissive_g.value = value["emissive"][1]
            emissive_b.value = value["emissive"][2]
            emissive_a.value = value["emissive"][3]

            shininess_cbx.checked = value["useShininess"]
            shininess_sb.value = value["shininess"]
            updating = false

        }
    }
    property bool updating: false

    function setSofaValue() {
        if (!sofaData || updating) return
        var newValue = name_tf.text
                + " Diffuse "   + (diffuse_cbx.checked ? 1 : 0)   + " " + diffuse_r.value  + ' ' + diffuse_g.value  + ' ' + diffuse_b.value  + ' ' + diffuse_a.value
                + " Ambient "   + (ambient_cbx.checked ? 1 : 0)   + " " + ambient_r.value  + ' ' + ambient_g.value  + ' ' + ambient_b.value  + ' ' + ambient_a.value
                + " Specular "  + (specular_cbx.checked ? 1 : 0)  + " " + specular_r.value + ' ' + specular_g.value + ' ' + specular_b.value + ' ' + specular_a.value
                + " Emissive "  + (emissive_cbx.checked ? 1 : 0)  + " " + emissive_r.value + ' ' + emissive_g.value + ' ' + emissive_b.value + ' ' + emissive_a.value
                + " Shininess " + (shininess_cbx.checked ? 1 : 0) + " " + shininess_sb.value
        sofaData.setValue(newValue)
    }

    ColumnLayout {
        spacing: -1
        anchors.fill: parent
        Layout.fillHeight: true

        RowLayout {
            id: nameLayout
            Layout.fillWidth: true
            Label {
                text: "name: "
                Layout.preferredWidth: 76
            }
            TextField {
                id: name_tf
                Layout.fillWidth: true
                position: cornerPositions['Top']
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
                spacing: -1
                // INITIALLY WANTED TO USE A REPEATER HERE... activeFocus:
                // It isn't possible because repeaters destroy / reconstruct their delegates when the model changes.
                // this makes spinbox lose focus while editing using mouse drags.
                // To alleviate the issue, one would think it's possible to modify the values inside the model instead of replacing the whole model.
                // Sadly this doesn't work either because repeaters don't notify their delegates when the modeldata change
                // Thus repeaters suck in this context, and I need to manually declare each spinbox. sucks
//                Repeater {
//                    id: diffuse_repeater
//                    model: d_model
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: modelData
//                        position: cornerPositions["Middle"]
//                        from: 0
//                        to: 1
//                        function setValue(value) {
//                            diffuse_model = diffuse_repeater.model
//                            diffuse_model[index] = value
//                            setSofaValue()
//                        }

//                        onValueChanged: {
//                            setValue(value)
//                        }
//                        onValueEditted: {
//                            setValue(value)
//                        }
//                    }
//                }
                SpinBox {
                    id: diffuse_r
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: diffuse_g
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: diffuse_b
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: diffuse_a
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
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
                spacing: -1
//                Repeater {
//                    id: ambient_repeater
//                    model: a_model
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: modelData
//                        position: cornerPositions["Middle"]
//                        from: 0
//                        to: 1
//                        function setValue()  {
//                            ambient_model = ambient_repeater.model
//                            ambient_model[index] = value
//                            setSofaValue()
//                        }

//                        onValueChanged: setValue(value)
//                        onValueEditted: setValue(value)
//                    }
//                }
                SpinBox {
                    id: ambient_r
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: ambient_g
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: ambient_b
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: ambient_a
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
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
                spacing: -1
//                Repeater {
//                    id: specular_repeater
//                    model: s_model
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: modelData
//                        position: cornerPositions["Middle"]
//                        from: 0
//                        to: 1
//                        function setValue() {
//                            specular_model = specular_repeater.model
//                            specular_model[index] = value
//                            setSofaValue()
//                        }

//                        onValueChanged: setValue(value)
//                        onValueEditted: setValue(value)
//                    }
//                }
                SpinBox {
                    id: specular_r
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: specular_g
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: specular_b
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: specular_a
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
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
                spacing: -1
//                Repeater {
//                    id: emissive_repeater
//                    model: e_model
//                    delegate: SpinBox {
//                        Layout.fillWidth: true
//                        value: modelData
//                        position: cornerPositions["Middle"]
//                        from: 0
//                        to: 1
//                        function setValue() {
//                            emissive_model = emissive_repeater.model
//                            emissive_model[index] = value
//                            setSofaValue()
//                        }

//                        onValueChanged: setValue(value)
//                        onValueEditted: setValue(value)
//                    }
//                }
                SpinBox {
                    id: emissive_r
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: emissive_g
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: emissive_b
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
                }
                SpinBox {
                    id: emissive_a
                    Layout.fillWidth: true
                    from: 0
                    to: 1

                    onValueChanged: {
                        setSofaValue()
                    }
                    position: cornerPositions["Middle"]
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
                position: cornerPositions["Bottom"]
            }
        }
    }
}
