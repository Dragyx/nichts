import Quickshell
import Quickshell.Hyprland
import Quickshell.Io // for Process
import QtQuick

Text {
    id: ws_icon
    MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + hypr_id)
    }
    property int hypr_id
    property string name
    text: toRomanNumeral(name)
    width: 100
    color: sysPalette.accent

    function toRomanNumeral(name) {
        if (name.isNaN) {
            return name;
        }
        var n = Number(name);
        var name = "";
        while (n > 0) {
            if (n >= 50) {
                n -= 50;
                name += 'L';
            } else if (n >= 40) {
                n -= 50;
                name += 'XL';
            } else if (n >= 10) {
                n -= 10;
                name += 'X';
            } else if (n == 9) {
                n -= 9;
                name += "IX";
            } else if (n == 8) {
                n -= 8;
                name += "IIX";
            } else if (n >= 5) {
                n -= 5;
                name += "V";
            } else if (n >= 4) {
                n -= 5;
                name += "IV";
            } else {
                n -= 1;
                name += 'I';
            }
        }

        return name;
    }
}
