import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: window

    function showMenu()
    {
        console.debug("BBPageStackWindow.showMenu();");
        window.isShowMenu = true;
    }

    function hideMenu()
    {
        console.debug("BBPageStackWindow.hideMenu();");
        window.isShowMenu = false;
    }

    signal upSwipe
    signal rightSwipe
    signal downSwipe
    signal leftSwipe

    signal upSwipeReleased
    signal rightSwipeReleased
    signal downSwipeReleased
    signal leftSwipeReleased

    property int diffSwipeX1: 80
    property int diffSwipeX2: 480 - 100
    property int offsetSwipeX: 40
    property int offsetSwipeY: 40

    property bool isShowMenu: false

    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack
    property Style platformStyle: PageStackWindowStyle{}
    property alias platformToolBarHeight: toolBar.height // read-only

    //Deprecated, TODO Remove this on w13
    property alias style: window.platformStyle

    //private api
    property int __statusBarHeight: showStatusBar ? statusBar.height : 0

    objectName: "pageStackWindow"

    StatusBar {
        id: statusBar
        anchors.top: parent.top
        width: parent.width
        showStatusBar: window.showStatusBar
    }

    onOrientationChangeStarted: {
        statusBar.orientation = screen.currentOrientation
    }

    Rectangle{
        id: backgroundMenu
        color: "#000000"
        anchors { top: statusBar.bottom; left: parent.left; bottom: parent.bottom; right: windowContent.left; }
        visible: windowContent.x > 0

        MouseArea{
            anchors.fill: parent
            onClicked: {
                window.isShowMenu = false;
            }
        }

        ListView{
            id: listViewMenu
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            delegate: SwipeListDelegate{}
            header: TextField{
                width: ListView.width
            }
        }
    }

    Rectangle {
        id: background
        visible: platformStyle.background == ""
        color: platformStyle.backgroundColor
        anchors { top: statusBar.bottom; left: windowContent.left; bottom: parent.bottom; right: windowContent.right; }
    }

    Image {
        id: backgroundImage
        visible: platformStyle.background != ""
        source: window.inPortrait ? platformStyle.portraitBackground : platformStyle.landscapeBackground
        fillMode: platformStyle.backgroundFillMode
        anchors { top: statusBar.bottom; left: windowContent.left; bottom: parent.bottom; right: windowContent.right; }
    }

    MouseArea {
        id: windowContent

        function checkDirection(oldX, oldY, newX, newY, offsetX, offsetY, rel){
            var xDiff = oldX - newX;
            var yDiff = oldY - newY;
            if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                if( oldX > newX) {
                    if(oldX - newX >= offsetX){
                        if(!rel)
                            window.leftSwipe();
                        else
                            window.leftSwipeReleased()
                    }
                } else {
                    if(newX - oldX >= offsetX){
                        if(!rel)
                            window.rightSwipe();
                        else
                            window.rightSwipeReleased();
                    }
                }
            } else {
                if( oldY > newY) {
                    if(oldY - newY >= offsetY){
                        /*up*/
                        if(!rel)
                            window.upSwipe();
                        else
                            window.upSwipeReleased()
                    }
                }
                else {
                    /*down*/
                    if(newY - oldY >= offsetY){
                        if(!rel)
                            window.downSwipe();
                        else
                            window.downSwipeReleased();
                    }
                }

            }
        }

        property int oldX: 0
        property int oldMouseX1: 0
        property int oldMouseX2: 0
        property int oldMouseY1: 0
        property int oldMouseY2: 0

        objectName: "appWindowContent"
        width: parent.width
        anchors.top: statusBar.bottom
        anchors.bottom: parent.bottom

        drag{
            target: windowContent
            axis: "XAxis"
            minimumX: 0
            maximumX: window.diffSwipeX2//480*0.75
            filterChildren: true
        }
        onPressed: {
            oldX = -1;

            if(!window.isShowMenu && mouseX < window.diffSwipeX1)
            {
                oldX = windowContent.x;
                windowContent.drag.target = windowContent;
            }
            else if(window.isShowMenu)
            {
                oldX = windowContent.x;
                windowContent.drag.target = windowContent;
            }

            if(oldX === -1){
                windowContent.drag.target = undefined;
                windowContent.x = 0;
            }

            // Para chequear direccion left o right.
            if(!window.isShowMenu)
            {
                oldMouseX1 = mouseX;
                oldMouseX2 = 0;
                oldMouseY1 = mouseY;
                oldMouseY2 = 0;
            }
        }
        onPositionChanged: {
            // Para chequear left o right.
            if(!window.isShowMenu)
            {
                oldMouseX2 = mouseX;
                oldMouseY2 = mouseY;

                //console.debug("mouseX: " + mouseX);
                windowContent.checkDirection(oldMouseX1, oldMouseY1,oldMouseX2, oldMouseY2, window.offsetSwipeX, window.offsetSwipeY);
            }
        }
        onReleased: {
            if(oldX == 0)
            {
                if(windowContent.x  > oldX + window.diffSwipeX1)
                {
                    if(!window.isShowMenu)
                        window.isShowMenu = true;
                }
                else{
                    windowContent.x = 0;
                    window.isShowMenu = false;
                }
            }
            else if(oldX == windowContent.drag.maximumX)
            {
                if(windowContent.x < oldX - window.diffSwipeX1)
                {
                    if(window.isShowMenu)
                        window.isShowMenu = false;
                }
                else
                {
                    windowContent.x = windowContent.drag.maximumX;
                    window.isShowMenu = true;

                }
            }

            if(windowContent.drag.target === undefined)
                windowContent.drag.target = windowContent;

        }

        // content area
        Item {
            id: contentArea
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; }
            anchors.bottomMargin: toolBar.visible || (toolBar.opacity==1)? toolBar.height : 0
            PageStack {
                id: stack
                anchors.fill: parent
                toolBar: toolBar
            }
        }

        Item {
            id: roundedCorners
            visible: platformStyle.cornersVisible
            anchors.fill: parent
            z: 10001

            Image {
                anchors.top : parent.top
                anchors.left: parent.left
                source: "image://theme/meegotouch-applicationwindow-corner-top-left"
            }
            Image {
                anchors.top: parent.top
                anchors.right: parent.right
                source: "image://theme/meegotouch-applicationwindow-corner-top-right"
            }
            Image {
                anchors.bottom : parent.bottom
                anchors.left: parent.left
                source: "image://theme/meegotouch-applicationwindow-corner-bottom-left"
            }
            Image {
                anchors.bottom : parent.bottom
                anchors.right: parent.right
                source: "image://theme/meegotouch-applicationwindow-corner-bottom-right"
            }
        }

        ToolBar {
            id: toolBar
            anchors.bottom: parent.bottom
            privateVisibility: (inputContext.softwareInputPanelVisible==true || inputContext.customSoftwareInputPanelVisible == true)
                               ? ToolBarVisibility.HiddenImmediately : (window.showToolBar ? ToolBarVisibility.Visible : ToolBarVisibility.Hidden)
        }

        Rectangle{
            id: contentOverlay
            color: "#000"
            anchors.fill: parent
            opacity: (windowContent.x * 0.8) / windowContent.drag.maximumX
            visible: windowContent.x > 0

            MouseArea{
                anchors.fill: parent
            }
        }

        Behavior on x{
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }

    states: [
        State{
            name: "hideMenu"
            when: !window.isShowMenu
            PropertyChanges{
                target: windowContent
                x: 0
            }
        },
        State{
            name: "showMenu"
            when: window.isShowMenu
            PropertyChanges{
                target: windowContent
                x: windowContent.drag.maximumX
            }
        }
    ]

    Component.onCompleted: {
        if (initialPage) pageStack.push(initialPage);
    }

}
