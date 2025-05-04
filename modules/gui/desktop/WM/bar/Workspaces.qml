import Quickshell
import Quickshell.Hyprland
import Quickshell.Io // for Process
import QtQuick
import QtQuick.Layouts 



ListView {
  id: wsView
  model: Hyprland.workspaces
  orientation: ListView.Horizontal
  delegate: wsDelegate
  anchors.fill: parent
  Component {
    id: wsDelegate
    WorkspaceIcon {
      required property HyprlandWorkspace modelData;
      name: modelData.name;
      hypr_id: modelData.id
    }
  }
}   
