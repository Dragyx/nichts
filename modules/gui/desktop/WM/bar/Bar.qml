import Quickshell
import Quickshell.Hyprland
import Quickshell.Io // for Process
import QtQuick
import QtQuick.Layouts 
import QtQuick.Controls.Fusion
import QtQuick.Layouts


ShellRoot {
  SystemPalette {id: sysPalette; colorGroup: SystemPalette.Active }

  
  PanelWindow {
    color: palette.base
    anchors {
      top: true
      left: true
      right: true
    }

    height: 20

    Workspaces {}
  }
  // background: Rectangle {
  //   color: SystemPalette.base
  // }
  // Rectangle {
  //   anchors.fill: parent
  //   color: sysPalette.base
  // }
}
