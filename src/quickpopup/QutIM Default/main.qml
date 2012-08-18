import QtQuick 1.0
import qutIM 0.3

Rectangle {
	id: main
	width: 250
    height: 100
	color: "#858585"
	smooth: true
	radius: 10
	opacity: 0.9
	
	PopupAttributes {
		id: attributes
		property int trimLength: 80
		frameStyle: PopupAttributes.ToolTip
	}

	Image {
		id: image
		source: "images/qutim.svg"
		width: 100
		fillMode: Image.PreserveAspectFit
		opacity: 0.7

		anchors {
			bottom:main.bottom
			right: main.right
			topMargin: 0
			leftMargin: 0
		}
	}

	Text {
		id: subject
		anchors {
			top: main.top
			right: image.right
			left: main.left
			topMargin: 10
			leftMargin: 15
			rightMargin: 100
		}

		elide: Text.ElideMiddle
		color: "#e6e6e6"
		font.bold: true
		style: Text.Outline
		styleColor: "#777777"
		font.pixelSize: body.font.pixelSize + 2
	}

	Text {
		id: body
		wrapMode: Text.Wrap

		anchors {
			top: subject.bottom
			left: subject.left
			right: subject.right
			topMargin: 5
		}

		color: "#e4e4e4"
		font.pixelSize: 12
	}

	ListView {
		id: actions
		z: 10
		height: 30
		orientation: ListView.Horizontal
		spacing: 10

		anchors {
			top: body.bottom
			left: body.left
			right: body.right
		}
		
		delegate: Text {
			id: actionDelegate
			text: model.modelData.text
			color: "#e6e6e6"
			style: Text.Sunken
			styleColor: "#858585"
			font.italic: true
			font.underline: true

			MouseArea {
				id: actionArea
				anchors.fill: parent

				hoverEnabled: true
				acceptedButtons: Qt.LeftButton

				onClicked: {
					console.log("Action: " + model.modelData);
					model.modelData.trigger();
					mouse.accepted = true;
				}
			}

			states: [
				State {
					name: "hovered"
					when: actionArea.containsMouse
					PropertyChanges {
						target: actionDelegate
						font.underline: false
					}
				},
				State {
					name: "leaved"
					when: !actionArea.containsMouse
					PropertyChanges {
						target: actionDelegate
						font.underline: true
					}
				},
				State {
					name: "pressed"
					when: actionArea.pressed
					
					PropertyChanges {
						target: actionDelegate
						font.underline: false
						font.bold: true
					}
				}
			]
		}
	}

	MouseArea {
		id: acceptIgnoreArea
		anchors.fill: main
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		
		onClicked: {
			console.log("Clicked");
            if (mouse.button === Qt.RightButton)
				popup.ignore();
			else
				popup.accept();
		}
	}
	Connections {
		target: popup
		onNotifyAdded: {
			var str = body.text;
			if (str.length && notify.text.length && str.length < attributes.trimLength)
				str = str + "<br /> ";
			str = str + notify.text;
			//trim
			if (str.length > attributes.trimLength)
				str = str.substring(0, attributes.trimLength - 3) + "...";
			body.text = str;

			subject.text = notify.title;
			actions.model = notify.actions;

			//TODO write image provider for avatars
            if (notify.avatar !== "undefined")
				image.source = notify.avatar;
		}
	}
}
