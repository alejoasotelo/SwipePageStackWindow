import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: pageTest

    property string title : "Test"

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Image {
        id: pageHeader
        anchors.top: parent.top

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
            text: pageTest.title
        }
    }

    ListView {
        id: listView
        anchors {
            top: pageHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 16
        }
        model: ListModel{id: listModel}
        delegate: ListDelegate{id: listDelegate}
    }

    ScrollDecorator {
        flickableItem: listView
    }

    Connections{
        target: pageTest.status === PageStatus.Active ? appWindow : null // Por si se agrega otro Item al pageStack
        ignoreUnknownSignals: true
        onRightSwipe: {
            console.debug("rightSwipe");
            pageStack.pop();
        }
    }

    Component.onCompleted: {
        var i =0;
        for(i = 0; i < 20; i++)
            listModel.append({title: "title " + i, subtitle: "subtitle " + i});
    }
}
