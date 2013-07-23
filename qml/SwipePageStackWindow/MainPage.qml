import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: page

    property string title : "SwipePageStackWindow Test"

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Image {
        id: pageHeader
        anchors {
            top: page.top
            left: page.left
            right: page.right
        }

        height: parent.width < parent.height ? 72 : 46
        width: parent.width
        source: "image://theme/meegotouch-view-header-fixed" + (theme.inverted ? "-inverted" : "")
        z: 1

        Label {
            id: header
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 16
            }
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 32
            }
            text: page.title
        }
    }

    ListView {
        id: listView
        anchors {
            top: pageHeader.bottom
            bottom: page.bottom
            left: page.left
            right: page.right
            margins: 16
        }
        model: ListModel{id: listModel}
        delegate: ListDelegate{
            id: listDelegate
            onClicked: {
                appWindow.pageStack.push(Qt.resolvedUrl("Test.qml"), {title: title});
            }
        }
    }

    ScrollDecorator {
        flickableItem: listView
    }

    Component.onCompleted: {
        var i =0;
        for(i = 0; i < 20; i++)
            listModel.append({title: "title " + i, subtitle: "subtitle " + i});
    }
}
