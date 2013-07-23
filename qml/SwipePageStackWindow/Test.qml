import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: pageTest

    property string title : "Test"

    //tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Image {
        id: pageHeader
        anchors.top: parent.top

        height: parent.width < parent.height ? 72 : 46
        width: parent.width
        source: "image://theme/meegotouch-view-header-fixed" + (theme.inverted ? "-inverted" : "")
        z: 1

        ListButton{
            id: btnBack
            style: ListButtonStyle {buttonHeight: 37}
            anchors{
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }
            text: qsTr("back")
            onClicked: pageStack.pop();
        }

        Label {
            id: header
            anchors {
                verticalCenter: parent.verticalCenter
                left: btnBack.right
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
        delegate: ListDelegate{
            id: listDelegate
        }
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
        onClicked:{
            if(type === "home")
                pageStack.pop();
            else if(type === "about")
                aboutDialog.open();
        }
    }

    onStatusChanged: {

        if(status === PageStatus.Activating)
        {
            listModel.clear();
            for(var i = 0; i < 20; i++)
                listModel.append({title: "title " + i, subtitle: "subtitle " + i});

            appWindow.menuModel.clear();
            appWindow.menuModel.append({title: "Home", type:"home", iconSource: "image://theme/icon-m-toolbar-home-white"});
            appWindow.menuModel.append({title: "About", type:"about", iconSource: "image://theme/icon-m-toolbar-view-menu-white"});
        }
    }
}
