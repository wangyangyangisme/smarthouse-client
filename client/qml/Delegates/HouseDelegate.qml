import QtQuick 2.6
import QtQuick.Layouts 1.1

import "../Controls" as Controls
import ".." as Global

Rectangle {
	id: __delegate

	property var house: null

	radius: 4
	color: Global.ApplicationStyle.background

    height: __houseLabel.height + __houseDescriptionLabel.height + __sensorsView.height + 40

	ListModel {
		id: __sensorsModel
	}

	ColumnLayout {

		spacing: 10

		anchors.top: __delegate.top; anchors.topMargin: 10
		anchors.left: __delegate.left; anchors.leftMargin: 10
		anchors.right: __delegate.right; anchors.rightMargin: 10

		Controls.LabelBold {
			id: __houseLabel
            text: !!house ? qsTr("%1").arg(house.name) : ""
		}

        Controls.LabelBold {
            id: __houseDescriptionLabel
            font.bold: false
            font.pixelSize: 12
            text: !!house ? qsTr("%1").arg(house.address) : ""
        }

		ListView {
			id: __sensorsView

			clip: true
			width: __delegate.width - 20

			model: __sensorsModel

			spacing: 10

			delegate: SensorDelegate{
				width: parent.width
                house: __delegate.house
				sensor: __sensorsModel.get(index)

				Component.onCompleted: {
					__sensorsView.height += height
				}
			}
		}
	}

	function updateModel(){
		__sensorsModel.clear()

		if(!house) return

		var sensorsRequestString = "users/" + Global.Application.restProvider.currentUserId()
		sensorsRequestString += "/houses/" + house.id
		sensorsRequestString += "/sensors"
		Global.Application.restProvider.list(sensorsRequestString, undefined, fillModel)
	}

	function fillModel(response){
		console.log("get sensors reply: ", JSON.stringify(response))
		if("answer" in response){
			var sensors = JSON.parse(response.answer)
			if(sensors.length){
				for( var i = 0; i < sensors.length; ++i){
					__sensorsModel.append(sensors[i])
				}
			}
		}
	}
}
