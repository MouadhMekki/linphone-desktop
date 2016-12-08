import QtQuick 2.7
import QtQuick.Layouts 1.3

import Common 1.0
import Common.Styles 1.0
import Utils 1.0

// ===================================================================

RowLayout {
  id: listForm

  property alias placeholder: placeholder.text
  property alias title: text.text
  property var defaultData: []

  // -----------------------------------------------------------------

  function _addValue (value) {
    values.model.append({ $value: value })

    if (value.length === 0) {
      addButton.enabled = false
    }
  }

  function _handleEditionFinished (index, text) {
    if (text.length === 0) {
      values.model.remove(index)
    } else {
      values.model.set(index, { $value: text })
    }

    addButton.enabled = true
  }

  // -----------------------------------------------------------------

  spacing: 0

  // -----------------------------------------------------------------
  // Title area.
  // -----------------------------------------------------------------

  RowLayout {
    Layout.alignment: Qt.AlignTop
    Layout.preferredHeight: ListFormStyle.lineHeight
    spacing: ListFormStyle.titleArea.spacing

    ActionButton {
      id: addButton

      icon: 'add'
      iconSize: ListFormStyle.titleArea.iconSize

      onClicked: _addValue('')
    }

    Text {
      id: text

      Layout.preferredWidth: ListFormStyle.titleArea.text.width
      color: ListFormStyle.titleArea.text.color
      elide: Text.ElideRight

      font {
        bold: true
        pointSize: ListFormStyle.titleArea.text.fontSize
      }
    }
  }

  // -----------------------------------------------------------------
  // Placeholder.
  // -----------------------------------------------------------------

  Text {
    id: placeholder

    Layout.fillWidth: true
    Layout.preferredHeight: ListFormStyle.lineHeight
    color: ListFormStyle.value.placeholder.color

    font {
      italic: true
      pointSize: ListFormStyle.value.placeholder.fontSize
    }

    padding: ListFormStyle.value.text.padding
    visible: values.model.count === 0
    verticalAlignment: Text.AlignVCenter

    MouseArea {
      anchors.fill: parent
      onClicked: _addValue('')
    }
  }

  // -----------------------------------------------------------------
  // Values.
  // -----------------------------------------------------------------

  ListView {
    id: values

    Layout.fillWidth: true
    Layout.preferredHeight: count * ListFormStyle.lineHeight
    interactive: false
    visible: model.count > 0

    delegate: Item {
      implicitHeight: textEdit.height
      width: parent.width

      TextEdit {
        id: textEdit

        text: $value
        height: ListFormStyle.lineHeight

        onEditingFinished: _handleEditionFinished(index, text)
      }

      Component.onCompleted: {
        if ($value.length === 0) {
          // Magic code. If it's the first inserted value,
          // an event or a callback steal the item focus.
          // I suppose it's an internal Qt qml event...
          //
          // So, I choose to run a callback executed after this
          // internal event.
          Utils.setTimeout(listForm, 0, function () {
            textEdit.forceActiveFocus()
          })
        }
      }
    }

    model: ListModel {}

    // ---------------------------------------------------------------
    // Init values.
    // ---------------------------------------------------------------

    Component.onCompleted: {
      if (!defaultData) {
        return
      }

      defaultData.forEach(function (data) {
        model.append({ $value: data })
      })
    }
  }
}