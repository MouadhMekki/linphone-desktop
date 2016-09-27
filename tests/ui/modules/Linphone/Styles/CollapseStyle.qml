pragma Singleton
import QtQuick 2.7

QtObject {
    property int animationDuration: 200
    property int iconSize: 32

    property string icon: 'collapse'

    property Rectangle background: Rectangle {
        // Do not use Constants.colors.
        // Collapse uses an icon without background color.
        color: 'transparent'
    }
}
