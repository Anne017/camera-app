/*
 * Copyright 2014 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import Ubuntu.Components 1.0
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 0.1

PopupBase {
    property var transferContentType 
    property var transferItems

    signal contentPeerSelected()

    fadingAnimation: UbuntuNumberAnimation { duration: UbuntuAnimation.SnapDuration }

    Component.onCompleted: {
        contentPeerPicker.peerSelected.connect(contentPeerSelected);
    }

    // FIXME: ContentPeerPicker should either have a background or not, not half of one
    Rectangle {
        anchors.fill: parent
        color: Theme.palette.normal.overlay
    }

    ContentPeerPicker {
        id: contentPeerPicker
        // FIXME: ContentPeerPicker should define an implicit size and not refer to its parent
        // FIXME: ContentPeerPicker should not be visible: false by default
        visible: true
        Component.onCompleted: {
            contentType = parent.transferContentType;
        }
        handler: ContentHandler.Share

        onPeerSelected: {
            var transfer = peer.request();
            if (transfer.state === ContentTransfer.InProgress) {
                transfer.items = parent.transferItems;
                transfer.state = ContentTransfer.Charged;
            }
            PopupUtils.close(sharePopover);
        }
        onCancelPressed: PopupUtils.close(sharePopover);
    }
}

