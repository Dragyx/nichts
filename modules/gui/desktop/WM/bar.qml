
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io // for Process
import QtQuick

ShellRoot {
  PanelWindow {
    anchors {
      top: true
      left: true
      right: true
    }

    height: 15

    function onWorkspaceReload(object, index) {
        workspacenumber.text = Hyprland.workspaces.values.length
    }


    Row {
      id: workspaces
      anchors.centerIn: parent
    }    

    function onNewWorkspace(workspace, index) {
      tmp = Text{
          text: index
      }
      workspaces.children.append(
      );
    }

    Text {
      // give the text an ID we can refer to elsewhere in the file
      id: workspacenumber

      anchors.centerIn: parent

    }
    Component.onCompleted: {
        Hyprland.workspaces.objectInsertedPost.connect(onWorkspaceReload)
        Hyprland.workspaces.objectRemovedPost.connect(onWorkspaceReload)
        onWorkspaceReload(null, null)
        Hyprland.workspaces.objectInsertedPost.connect(onNewWorkspace)
    }
  }
}
