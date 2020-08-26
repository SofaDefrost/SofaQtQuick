import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import SofaBasics 1.0
import TemplateAsset 1.0

Item {
    id: root
    property TemplateAsset selectedAsset

    GroupBox {
        width: root.parent.width
        title: "Mesh properties"
        
        Column {
             RowLayout {
                spacing: 10
                width: root.parent.width - 40
                Label {
                    color: "black"
                    id: primitiveTypeLbl
                    Layout.fillWidth: true
                    text: "Primitive type: "
                    wrapMode: Text.Wrap
                }
                Label {
                    color: "#eeeeec"
                    id: primitiveType
                    text: selectedAsset.callAssetScriptFunction("primitiveType")
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}

