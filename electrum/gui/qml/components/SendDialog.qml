import QtQuick 2.6
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0

import org.electrum 1.0

import "controls"

ElDialog {
    id: dialog

    property InvoiceParser invoiceParser

    parent: Overlay.overlay
    modal: true
    standardButtons: Dialog.Close

    Overlay.modal: Rectangle {
        color: "#aa000000"
    }

    padding: 0

    function restart() {
        qrscan.restart()
    }

    ColumnLayout {
        anchors.fill: parent

        QRScan {
            id: qrscan
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            onFound: invoiceParser.recipient = scanData
        }

        FlatButton {
            Layout.fillWidth: true
            icon.source: '../../icons/pen.png'
            text: qsTr('Manual input')
            onClicked: {
                var _mid = manualInputDialog.createObject(mainView)
                _mid.accepted.connect(function() {
                    invoiceParser.recipient = _mid.recipient
                })
                _mid.open()
            }
        }

        FlatButton {
            Layout.fillWidth: true
            icon.source: '../../icons/paste.png'
            text: qsTr('Paste from clipboard')
            onClicked: invoiceParser.recipient = AppController.clipboardToText()
        }
    }

    Component {
        id: manualInputDialog
        ElDialog {
            property alias recipient: recipientTextEdit.text

            anchors.centerIn: parent
            implicitWidth: parent.width * 0.9

            parent: Overlay.overlay
            modal: true
            standardButtons: Dialog.Ok

            Overlay.modal: Rectangle {
                color: "#aa000000"
            }

            title: qsTr('Manual Input')

            ColumnLayout {
                width: parent.width

                Label {
                    text: 'Enter a bitcoin address or a Lightning invoice'
                    wrapMode: Text.Wrap
                }

                TextField {
                    id: recipientTextEdit
                    topPadding: constants.paddingXXLarge
                    bottomPadding: constants.paddingXXLarge
                    Layout.preferredWidth: parent.width
                    font.family: FixedFont

                    wrapMode: TextInput.WrapAnywhere
                    placeholderText: qsTr('Enter the payment request here')
                }
            }

            onClosed: destroy()
        }
    }
}
