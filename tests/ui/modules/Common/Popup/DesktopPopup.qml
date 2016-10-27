import QtQuick 2.7
import QtQuick.Window 2.2

import Common.Styles 1.0

// ===================================================================

Item {
  id: wrapper

  property alias popupX: popup.x
  property alias popupY: popup.y

  default property alias _content: content.data
  property bool _isOpen: false

  function show () {
    _isOpen = true
  }

  function hide () {
    _isOpen = false
  }

  // DO NOT TOUCH THIS PROPERTIES.

  // No visible.
  visible: false

  // No size, no position.
  height: 0
  width: 0
  x: 0
  y: 0

  Window {
    id: popup

    flags: Qt.SplashScreen
    opacity: 0
    height: _content[0] != null ? _content[0].height : 0
    width: _content[0] != null ? _content[0].width : 0

    Item {
      id: content

      // Fake parent.
      property var $parent: wrapper
    }
  }

  // -----------------------------------------------------------------

  states: State {
    name: 'opened'
    when: _isOpen

    PropertyChanges {
      opacity: 1.0
      target: popup
    }
  }

  transitions: [
    Transition {
      from: ''
      to: 'opened'

      ScriptAction {
        script: popup.show()
      }

      NumberAnimation {
        duration: PopupStyle.animation.openingDuration
        easing.type: Easing.InOutQuad
        property: 'opacity'
        target: popup
      }
    },

    Transition {
      from: 'opened'
      to: ''

      NumberAnimation {
        duration: PopupStyle.animation.closingDuration
        easing.type: Easing.InOutQuad
        property: 'opacity'
        target: popup
      }

      SequentialAnimation {
        PauseAnimation {
          duration: PopupStyle.animation.closingDuration
        }

        ScriptAction {
          script: popup.hide()
        }
      }
    }
  ]
}
