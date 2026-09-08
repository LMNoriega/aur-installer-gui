import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 740
    height: 560
    visible: true
    title: "Instalador AUR"
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window

    // Paleta de colores de Serpantinum
    readonly property var theme: backend.theme

    property bool isUninstallMode: false
    readonly property color currentAccent: isUninstallMode ? theme.red : theme.mauve

    Component.onCompleted: {
        searchInput.forceFocus();
    }

    TextMetrics {
        id: fontMetrics
        font.family: "JetBrains Mono"
        font.pixelSize: 13
        font.bold: true
        text: "0"
    }

    // Contenedor principal con efecto de vidrio esmerilado / liquid glass (translúcido + blur)
    Rectangle {
        id: bgContainer
        anchors.fill: parent
        radius: 14
        color: Qt.alpha(theme.base, 0.76)
        border.color: Qt.alpha(currentAccent, 0.55)
        border.width: 1.5
        clip: true

        Behavior on border.color {
            ColorAnimation { duration: 250 }
        }
        Behavior on color {
            ColorAnimation { duration: 250 }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // ================= HEADER & TABS =================
            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                // Selector de modo con píldora animada (Instalar vs Desinstalar)
                Rectangle {
                    id: modeToggle
                    Layout.preferredWidth: 230
                    Layout.preferredHeight: 36
                    radius: 10
                    color: Qt.alpha(theme.surface0, 0.65)
                    border.color: Qt.alpha(theme.surface2, 0.70)
                    border.width: 1

                    // Fondo deslizante animado del tab activo
                    Rectangle {
                        id: tabHighlight
                        width: (parent.width - 6) / 2
                        height: parent.height - 6
                        y: 3
                        x: root.isUninstallMode ? (parent.width / 2) : 3
                        radius: 8
                        color: Qt.alpha(root.isUninstallMode ? theme.red : theme.mauve, 0.90)

                        Behavior on x {
                            NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 1.15 }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 220 }
                        }
                    }

                    Row {
                        anchors.fill: parent
                        Item {
                            width: parent.width / 2
                            height: parent.height
                            Text {
                                anchors.centerIn: parent
                                text: "📦 Instalar"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 12
                                font.bold: true
                                color: !root.isUninstallMode ? theme.crust : theme.subtext0
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (root.isUninstallMode) {
                                        root.isUninstallMode = false;
                                        backend.playSwitchSound();
                                        backend.setMode("install", searchInput.inputText);
                                        searchInput.forceFocus();
                                    }
                                }
                            }
                        }
                        Item {
                            width: parent.width / 2
                            height: parent.height
                            Text {
                                anchors.centerIn: parent
                                text: "🗑️ Desinstalar"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 12
                                font.bold: true
                                color: root.isUninstallMode ? theme.crust : theme.subtext0
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (!root.isUninstallMode) {
                                        root.isUninstallMode = true;
                                        backend.playSwitchSound();
                                        backend.setMode("uninstall", searchInput.inputText);
                                        searchInput.forceFocus();
                                    }
                                }
                            }
                        }
                    }
                }

                // Subtítulo informativo con espacio holgado
                Column {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: root.isUninstallMode ? "Desinstalador de Apps" : "Instalador de AUR"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 14
                        font.bold: true
                        color: root.currentAccent
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    Text {
                        text: root.isUninstallMode ? "Paquetes AUR y aplicaciones del sistema" : "Repositorio AUR y repos oficiales"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 11
                        color: theme.subtext0
                    }
                }

                // Indicador de atajos en la esquina derecha
                Text {
                    text: "[Tab] Modo • [Esc] Salir"
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    color: theme.subtext1
                }
            }

            // ================= SEARCH BAR (FROSTED GLASS) =================
            Rectangle {
                id: searchBarContainer
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                radius: 10
                color: Qt.alpha(theme.surface0, 0.65)
                border.width: 1.5
                border.color: innerInput.activeFocus ? root.currentAccent : Qt.alpha(theme.surface1, 0.70)

                property real focusPop: 1.0
                scale: focusPop

                Behavior on border.color { ColorAnimation { duration: 180 } }
                Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutQuint } }

                SequentialAnimation {
                    id: focusPopAnim
                    NumberAnimation { target: searchBarContainer; property: "focusPop"; to: 1.02; duration: 90; easing.type: Easing.OutQuad }
                    NumberAnimation { target: searchBarContainer; property: "focusPop"; to: 1.0; duration: 200; easing.type: Easing.OutQuint }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        text: root.isUninstallMode ? "󰍉" : "🔍"
                        font.pixelSize: 14
                        color: innerInput.activeFocus ? root.currentAccent : theme.subtext0
                    }

                    Item {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        property alias inputText: innerInput.text

                        function forceFocus() {
                            innerInput.forceActiveFocus();
                        }

                        function clear() {
                            innerInput.text = "";
                            charModel.clear();
                            backend.search("", root.isUninstallMode);
                        }

                        function syncChars(newText) {
                            if (newText.length > charModel.count && newText.startsWith(getCurrentModelText())) {
                                for (let i = charModel.count; i < newText.length; i++) {
                                    charModel.append({ "char": newText[i] });
                                }
                            } else if (newText.length < charModel.count && getCurrentModelText().startsWith(newText)) {
                                while (charModel.count > newText.length) {
                                    charModel.remove(charModel.count - 1);
                                }
                            } else {
                                charModel.clear();
                                for (let i = 0; i < newText.length; i++) {
                                    charModel.append({ "char": newText[i] });
                                }
                            }
                        }

                        function getCurrentModelText() {
                            let str = "";
                            for (let i = 0; i < charModel.count; i++) {
                                str += charModel.get(i).char;
                            }
                            return str;
                        }

                        // Placeholder
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.isUninstallMode
                                  ? "Escribe para filtrar apps instaladas (ej: spotify, zen, discord)..."
                                  : "Escribe para buscar en AUR (ej: spotify, discord, visual-studio)..."
                            font.family: "JetBrains Mono"
                            font.pixelSize: 12
                            color: theme.subtext1
                            opacity: (innerInput.text.length === 0 && charModel.count === 0) ? 0.6 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 140 } }
                        }

                        // Modelo de caracteres
                        ListModel { id: charModel }

                        // Fila de caracteres con animación de entrada (bouncy pop)
                        Row {
                            id: charRow
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Repeater {
                                model: charModel
                                delegate: Item {
                                    width: Math.max(fontMetrics.width, charText.implicitWidth)
                                    height: charRow.height

                                    Text {
                                        id: charText
                                        anchors.centerIn: parent
                                        text: model.char
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 13
                                        font.bold: true
                                        color: theme.text
                                        scale: 0.2
                                        y: 8
                                        opacity: 0

                                        ParallelAnimation {
                                            running: true
                                            NumberAnimation { target: charText; property: "scale"; to: 1.0; duration: 280; easing.type: Easing.OutBack; easing.overshoot: 3.2 }
                                            NumberAnimation { target: charText; property: "y"; to: 0; duration: 280; easing.type: Easing.OutBack; easing.overshoot: 2.2 }
                                            NumberAnimation { target: charText; property: "opacity"; to: 1.0; duration: 100 }
                                        }
                                    }
                                }
                            }
                        }

                        // Caret deslizante animado
                        Rectangle {
                            id: caretRect
                            width: 2
                            height: 16
                            color: root.currentAccent
                            visible: innerInput.activeFocus
                            anchors.verticalCenter: parent.verticalCenter
                            x: Math.min(innerInput.cursorPosition * (fontMetrics.width + 1) + 2, parent.width - 4)

                            Behavior on x {
                                NumberAnimation { duration: 160; easing.type: Easing.OutQuad }
                            }
                            Behavior on color {
                                ColorAnimation { duration: 180 }
                            }

                            SequentialAnimation on opacity {
                                running: innerInput.activeFocus
                                loops: Animation.Infinite
                                NumberAnimation { to: 0; duration: 100; easing.type: Easing.InQuad }
                                PauseAnimation { duration: 400 }
                                NumberAnimation { to: 1; duration: 100; easing.type: Easing.OutQuad }
                                PauseAnimation { duration: 400 }
                            }
                        }

                        // TextInput subyacente que mantiene siempre el foco
                        TextInput {
                            id: innerInput
                            anchors.fill: parent
                            opacity: 0
                            focus: true

                            onActiveFocusChanged: {
                                if (activeFocus) focusPopAnim.restart();
                            }

                            onTextEdited: {
                                searchInput.syncChars(text);
                                backend.playTypeSound();
                                backend.search(text, root.isUninstallMode);
                            }

                            Keys.onDownPressed: function(event) {
                                if (pkgList.count > 0) {
                                    if (pkgList.currentIndex < pkgList.count - 1) {
                                        pkgList.currentIndex++;
                                    } else {
                                        pkgList.currentIndex = 0;
                                    }
                                    pkgList.positionViewAtIndex(pkgList.currentIndex, ListView.Contain);
                                    backend.playSwitchSound();
                                }
                                event.accepted = true;
                            }

                            Keys.onUpPressed: function(event) {
                                if (pkgList.count > 0) {
                                    if (pkgList.currentIndex > 0) {
                                        pkgList.currentIndex--;
                                    } else {
                                        pkgList.currentIndex = pkgList.count - 1;
                                    }
                                    pkgList.positionViewAtIndex(pkgList.currentIndex, ListView.Contain);
                                    backend.playSwitchSound();
                                }
                                event.accepted = true;
                            }

                            Keys.onTabPressed: function(event) {
                                root.isUninstallMode = !root.isUninstallMode;
                                backend.playSwitchSound();
                                backend.setMode(root.isUninstallMode ? "uninstall" : "install", innerInput.text);
                                event.accepted = true;
                            }

                            Keys.onReturnPressed: function(event) {
                                if (pkgList.count > 0 && pkgList.currentIndex >= 0) {
                                    let item = backend.getItem(pkgList.currentIndex);
                                    if (item && item.name) {
                                        backend.playClickSound();
                                        backend.executeAction(item.name, root.isUninstallMode);
                                    }
                                } else if (innerInput.text.trim().length > 0) {
                                    backend.playClickSound();
                                    backend.executeAction(innerInput.text.trim(), root.isUninstallMode);
                                }
                                event.accepted = true;
                            }

                            Keys.onEscapePressed: function(event) {
                                root.close();
                                event.accepted = true;
                            }
                        }
                    }

                    // Botón limpiar texto
                    Item {
                        width: 24
                        height: 24
                        visible: innerInput.text.length > 0
                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: clearMa.containsMouse ? Qt.alpha(theme.surface1, 0.70) : "transparent"
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 11
                            color: theme.subtext0
                        }
                        MouseArea {
                            id: clearMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                backend.playClickSound();
                                searchInput.clear();
                                innerInput.forceActiveFocus();
                            }
                        }
                    }
                }
            }

            // ================= STATUS & SECURITY BADGE =================
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    id: statusLabel
                    Layout.fillWidth: true
                    text: backend.statusText
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    color: theme.subtext0
                    elide: Text.ElideRight
                }

                Rectangle {
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: secBadgeText.implicitWidth + 12
                    radius: 5
                    color: Qt.alpha(theme.green, 0.12)
                    border.color: Qt.alpha(theme.green, 0.35)
                    border.width: 1

                    Text {
                        id: secBadgeText
                        anchors.centerIn: parent
                        text: "🛡️ sudoers (NOPASSWD)"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 10
                        font.bold: true
                        color: theme.green
                    }
                }
            }

            // ================= LIST OF PACKAGES (LAUNCHER.QML STYLE) =================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: pkgList
                    anchors.fill: parent
                    clip: true
                    spacing: 4
                    model: backend.results
                    currentIndex: 0
                    boundsBehavior: Flickable.StopAtBounds
                    focus: false

                    onModelChanged: {
                        currentIndex = 0;
                    }

                    onCurrentIndexChanged: {
                        if (currentIndex >= 0) {
                            positionViewAtIndex(currentIndex, ListView.Contain);
                        }
                    }

                    // Morphing highlight de Serpantinum
                    Rectangle {
                        id: morphHighlight
                        parent: pkgList.contentItem
                        z: 0
                        visible: pkgList.count > 0 && pkgList.currentIndex >= 0
                        width: pkgList.width
                        height: 48
                        radius: 10
                        color: Qt.alpha(root.currentAccent, 0.90)

                        opacity: (pkgList.currentIndex >= 0 && pkgList.currentItem) ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }

                        property real targetY: (pkgList.currentIndex >= 0 && pkgList.currentItem) ? pkgList.currentItem.y : 0
                        y: targetY

                        Behavior on y {
                            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 220 }
                        }
                    }

                    delegate: Item {
                        id: delegateRoot
                        width: pkgList.width
                        height: 48
                        z: 1

                        readonly property bool isSelected: index === pkgList.currentIndex

                        Rectangle {
                            anchors.fill: parent
                            radius: 10
                            color: Qt.alpha(theme.surface0, 0.50)
                            opacity: delegateMa.containsMouse && !delegateRoot.isSelected ? 0.60 : 0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                        }

                        RowLayout {
                            id: rowContent
                            anchors.fill: parent
                            anchors.leftMargin: 12 + (delegateRoot.isSelected ? 4 : 0)
                            anchors.rightMargin: 14
                            spacing: 10

                            Behavior on anchors.leftMargin {
                                NumberAnimation { duration: 180; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                            }

                            // Columna con Nombre y Descripción
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                RowLayout {
                                    spacing: 8
                                    Text {
                                        text: modelData.name
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 13
                                        font.bold: true
                                        color: delegateRoot.isSelected ? theme.crust : theme.text
                                    }
                                    Text {
                                        text: modelData.version
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 10
                                        color: delegateRoot.isSelected ? Qt.darker(theme.crust, 1.3) : theme.subtext1
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.description || "Sin descripción disponible"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    color: delegateRoot.isSelected ? Qt.darker(theme.crust, 1.4) : theme.subtext0
                                }
                            }

                            // Badge a la derecha
                            Rectangle {
                                Layout.preferredHeight: 22
                                Layout.preferredWidth: badgeText.implicitWidth + 14
                                radius: 6
                                color: {
                                    if (delegateRoot.isSelected) return Qt.alpha(theme.crust, 0.25);
                                    if (root.isUninstallMode) return Qt.alpha(theme.red, 0.20);
                                    return modelData.is_aur ? Qt.alpha(theme.mauve, 0.25) : Qt.alpha(theme.surface2, 0.80);
                                }
                                border.color: {
                                    if (delegateRoot.isSelected) return Qt.alpha(theme.crust, 0.4);
                                    return root.isUninstallMode ? theme.red : (modelData.is_aur ? theme.mauve : theme.surface2);
                                }
                                border.width: 1

                                Text {
                                    id: badgeText
                                    anchors.centerIn: parent
                                    text: {
                                        if (root.isUninstallMode) {
                                            return modelData.installed_size ? ("🗑️ " + modelData.installed_size) : "🗑️ Desinstalar";
                                        }
                                        if (modelData.is_aur) {
                                            return modelData.votes > 0 ? ("AUR ★" + modelData.votes) : "AUR";
                                        }
                                        return modelData.repo || "Repo";
                                    }
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: delegateRoot.isSelected ? theme.crust : (root.isUninstallMode ? theme.red : theme.text)
                                }
                            }
                        }

                        MouseArea {
                            id: delegateMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                pkgList.currentIndex = index;
                                backend.playClickSound();
                                backend.executeAction(modelData.name, root.isUninstallMode);
                            }
                        }
                    }

                    // En caso de que se haga foco en pkgList, redirigir inmediatamente a innerInput
                    Keys.onPressed: function(event) {
                        innerInput.forceActiveFocus();
                    }
                }
            }
        }
    }
}
