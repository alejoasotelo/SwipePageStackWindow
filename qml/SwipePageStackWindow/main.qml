import QtQuick 1.1
import com.nokia.meego 1.0

SwipePageStackWindow {
    id: appWindow

    initialPage: mainPage
    showStatusBar: false


    style: PageStackWindowStyle{cornersVisible: false}

    /*onRightSwipe: {
        console.debug("onRightSwipe");
    }*/

    MainPage {
        id: mainPage
    }

    /*ToolBarLayout {
        id: commonTools

        ToolIcon {
            visible: pageStack.depth > 1
            platformIconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

        ToolButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: theme.inverted ? "Inverted" : "Non-Inverted"
            onClicked: {
                theme.inverted = !theme.inverted;
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: {
                appWindow.showToolBar = false;
                myMenu.open();
            }
        }
    }*/

    QueryDialog {
        id: aboutDialog
        titleText: "SwipePageStackWindow"
        message: "(C) [2013] [AlejoSotelo.com.ar]\n[0.1.0]"
    }

    /*Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    aboutDialog.open();
                }
            }
        }
        onStatusChanged: {
            if (status === DialogStatus.Closed) {
                appWindow.showToolBar = true;
            }
        }
    }*/
}
