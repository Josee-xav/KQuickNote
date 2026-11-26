    // Displays one note at a time and automatically slides to the next note.
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import org.kde.plasma.plasmoid
    import org.kde.kirigami as Kirigami
    import org.kde.plasma.components as PC3
    import org.kde.plasma.extras as PlasmaExtras
    import org.kde.plasma.core as PlasmaCore

    PlasmoidItem {
        id: root

        property Item representationRef: null // messsssss

        property int currentIndex: 0
        property int slideDirection: 1
        property bool editing: false
        property bool loading: false
        property int rotationSeconds: plasmoid.configuration.rotationSeconds || 10
        property bool autoAdvance: plasmoid.configuration.autoAdvance === undefined
        ? true : plasmoid.configuration.autoAdvance

        Plasmoid.status: PlasmaCore.Types.ActiveStatus
        Plasmoid.icon: "accessories-text-editor"
        toolTipMainText: "Markdown Sticky Notes"
        toolTipSubText: notesModel.count > 0
        ? notesModel.get(Math.min(currentIndex, notesModel.count - 1)).title
        : "No notes yet"

        switchWidth: Kirigami.Units.gridUnit * 8
            switchHeight: Kirigami.Units.gridUnit * 6

                ListModel {
                    id: notesModel
                }

                Timer {
                    id: rotationTimer
                    interval: Math.max(1, root.rotationSeconds) * 1000
                    repeat: true
                    running: root.autoAdvance && notesModel.count > 1 && !root.editing
                    onTriggered: root.showNext(1)
                }

                function saveNotes() {
                    const notes = []
                    for (let i = 0; i < notesModel.count; ++i) {
                        const note = notesModel.get(i)
                        notes.push({ title: note.title, content: note.content })
                    }
                    plasmoid.configuration.notes = JSON.stringify(notes)
                    plasmoid.configuration.rotationSeconds = rotationSeconds
                    plasmoid.configuration.autoAdvance = autoAdvance
                }

                function loadNotes() {
                    loading = true
                    notesModel.clear()
                    try {
                        const saved = JSON.parse(plasmoid.configuration.notes || "[]")
                        for (const note of saved) {
                            notesModel.append({
                                title: note.title || "Untitled note",
                                content: note.content || ""
                            })
                        }
                    } catch (error) {
                        console.warn("Could not load sticky notes:", error)
                    }
                    currentIndex = notesModel.count > 0 ? 0 : -1
                    loading = false
                }

                function showNext(direction) {
                    if (notesModel.count < 2)
                        return
                        slideDirection = direction
                        currentIndex = (currentIndex + direction + notesModel.count) % notesModel.count
                        representationRef.slideAnimation.restart()
                }

                function addNote() {
                    notesModel.append({
                        title: Qt.formatDateTime(new Date(), "dd.MM.yyyy hh:mm"),
                                    content: ""
                    })
                    console.log("Visible:")
                    currentIndex = notesModel.count - 1
                    editing = true
                    slideDirection = 1
                    representationRef.slideAnimation.restart()
                    saveNotes()

                    console.log("emdd:")
                }

                function deleteCurrentNote() {
                    if (currentIndex < 0 || notesModel.count === 0)
                        return

                    notesModel.remove(currentIndex)

                    currentIndex = -1

                    Qt.callLater(function() {
                        if (notesModel.count > 0) {
                            currentIndex = 0
                        }

                        noteContent.x = noteContent.width
                        representationRef.slideAnimation.restart()
                        root.saveNotes()
                    })
                }

                compactRepresentation: Item {
                    Layout.minimumWidth: Kirigami.Units.iconSizes.small
                    Layout.minimumHeight: Kirigami.Units.iconSizes.small
                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    Layout.preferredHeight: Kirigami.Units.iconSizes.small

                    PC3.ToolButton {
                        anchors.fill: parent
                        icon.name: "accessories-text-editor"
                        text: "Sticky Notes"
                        display: PC3.ToolButton.IconOnly
                        onClicked: root.expanded = !root.expanded
                    }
                }

                fullRepresentation: PlasmaExtras.Representation {
                    id: representation
                    Layout.minimumWidth: Kirigami.Units.gridUnit * 25
                    Layout.minimumHeight: Kirigami.Units.gridUnit * 22
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 26
                    collapseMarginsHint: true

                    property alias slideAnimation: slideIn

                    Component.onCompleted: {
                        root.representationRef = representation
                    }

                    // top bit sticky notes and nvagivation delete note add ntoe
                    contentItem: ColumnLayout {
                        spacing: Kirigami.Units.smallSpacing

                        // Toolbar
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PC3.Label {
                                text: "Sticky Notes"
                                font.bold: true
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.2
                            }

                            PC3.ToolButton {
                                icon.name: "go-previous"
                                display: PC3.ToolButton.IconOnly
                                enabled: notesModel.count > 1
                                onClicked: {
                                    rotationTimer.restart()
                                    root.showNext(-1)
                                }
                            }

                            PC3.Label {
                                Layout.minimumWidth: Kirigami.Units.gridUnit * 3
                                horizontalAlignment: Text.AlignHCenter
                                text: notesModel.count > 0
                                ? (root.currentIndex + 1) + " / " + notesModel.count
                                : "0 / 0"
                            }

                            PC3.ToolButton {
                                icon.name: "go-next"
                                display: PC3.ToolButton.IconOnly
                                enabled: notesModel.count > 1
                                onClicked: {
                                    rotationTimer.restart()
                                    root.showNext(1)
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            PC3.CheckBox {
                                text: "Auto"
                                checked: root.autoAdvance
                                onToggled: {
                                    root.autoAdvance = checked
                                    root.saveNotes()
                                }
                            }

                            SpinBox {
                                id: intervalBox
                                from: 2
                                to: 3600
                                editable: true
                                value: root.rotationSeconds
                                textFromValue: function(value) { return value + "s" }
                                valueFromText: function(text) {
                                    return Number(text.replace("s", ""))
                                }
                                onValueModified: {
                                    root.rotationSeconds = value
                                    root.saveNotes()
                                    rotationTimer.restart()
                                }
                            }

                            PC3.ToolButton {
                                icon.name: "list-add"
                                display: PC3.ToolButton.IconOnly
                                onClicked: root.addNote()
                            }

                            PC3.ToolButton {
                                icon.name: root.editing ? "document-save" : "document-edit"
                                display: PC3.ToolButton.IconOnly
                                enabled: currentIndex >= 0
                                onClicked: {
                                    root.editing = !root.editing
                                    if (!root.editing)
                                        root.saveNotes()
                                }
                            }

                            PC3.ToolButton {
                                icon.name: "edit-delete"
                                display: PC3.ToolButton.IconOnly
                                enabled: currentIndex >= 0
                                onClicked: deleteDialog.open()
                            }
                        }

                        // Rotation controls
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 0

                            radius: Kirigami.Units.cornerRadius
                            color: Kirigami.Theme.alternateBackgroundColor
                            clip: true

                            Item {
                                id: itemm

                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.largeSpacing
                                clip: true

                                Rectangle {
                                    anchors.fill: noteContent
                                    color: Kirigami.Theme.backgroundColor
                                    radius: Kirigami.Units.smallSpacing
                                    border.color: "red"
                                    z: -1
                                }

                                ColumnLayout {
                                    id: noteContent

                                    width: parent.width
                                    height: parent.height
                                    spacing: Kirigami.Units.smallSpacing
                                    x: 0

                                    // note titkle
                                    TextField {
                                        id: titleField

                                        Layout.fillWidth: true
                                        visible: root.currentIndex >= 0

                                        text: root.currentIndex >= 0
                                        ? notesModel.get(root.currentIndex).title : ""

                                        placeholderText: "Note title"
                                        font.bold: true

                                        onTextEdited: {
                                            if (root.currentIndex >= 0) {
                                                notesModel.setProperty(root.currentIndex, "title", text)
                                                root.saveNotes()
                                            }
                                        }
                                    }

                                    // text area for editing

                                    ScrollView {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumHeight: 0

                                        visible: root.editing && root.currentIndex >= 0

                                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                                        TextArea {
                                            id: noteEditor

                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.minimumHeight: 0


                                            text: root.currentIndex >= 0
                                            ? notesModel.get(root.currentIndex).content : ""

                                            wrapMode: TextEdit.WordWrap
                                            selectByMouse: true

                                            onTextChanged: {
                                                if (activeFocus && root.currentIndex >= 0) {
                                                    notesModel.setProperty(root.currentIndex, "content", text)
                                                    root.saveNotes()
                                                }
                                            }
                                        }
                                    }


                                    // text area for viewing read only
                                    ScrollView {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumHeight: 0

                                        visible: !root.editing && root.currentIndex >= 0

                                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                                        TextArea {
                                            textFormat: TextEdit.MarkdownText
                                            text: root.currentIndex >= 0
                                            ? notesModel.get(root.currentIndex).content : ""
                                            wrapMode: TextEdit.WordWrap
                                            readOnly: true
                                            selectByMouse: true
                                        }
                                    }

                                    PlasmaExtras.PlaceholderMessage {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        visible: root.currentIndex < 0
                                        text: "No notes yet"
                                        explanation: "Select + to create your first Markdown note"
                                        iconName: "accessories-text-editor"
                                    }
                                }

                                NumberAnimation {
                                    id: slideIn
                                    target: noteContent
                                    property: "x"
                                    from: root.slideDirection * itemm.width
                                    to: 0
                                    duration: 240
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }
                }

                PC3.Dialog {
                    id: deleteDialog
                    title: "Delete this note?"
                    modal: true
                    standardButtons: Dialog.Yes | Dialog.No
                    onAccepted: root.deleteCurrentNote()
                }

                Component.onCompleted: loadNotes()
    }
