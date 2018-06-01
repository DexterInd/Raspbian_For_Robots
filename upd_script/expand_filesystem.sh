
# This code is taken straight out of raspi-config
# it is currently not called from anywhere

do_expand_rootfs() {

    ROOT_PART=$(mount | sed -n 's|^/dev/\(.*\) on / .*|\1|p')

    PART_NUM=${ROOT_PART#mmcblk0p}
    if [ "$PART_NUM" = "$ROOT_PART" ]; then
    whiptail --msgbox "$ROOT_PART is not an SD card. Don't know how to expand" 20 60 2
    return 0
    fi


    LAST_PART_NUM=$(parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)
    if [ $LAST_PART_NUM -ne $PART_NUM ]; then
    whiptail --msgbox "$ROOT_PART is not the last partition. Don't know how to expand" 20 60 2
    return 0
    fi

    # Get the starting offset of the root partition
    PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d: | sed 's/[^0-9]//g')
    [ "$PART_START" ] || return 1
    # Return value will likely be error for fdisk as it fails to reload the
    # partition table because the root fs is mounted
    fdisk /dev/mmcblk0 <<EOF
    p
    d
    $PART_NUM
    n
    p
    $PART_NUM
    $PART_START

    p
    w
    EOF
    ASK_TO_REBOOT=1

    # now set up an init.d script
    cat <<EOF > /etc/init.d/resize2fs_once &&
    #!/bin/sh
    ### BEGIN INIT INFO
    # Provides:          resize2fs_once
    # Required-Start:
    # Required-Stop:
    # Default-Start: 3
    # Default-Stop:
    # Short-Description: Resize the root filesystem to fill partition
    # Description:
    ### END INIT INFO

    . /lib/lsb/init-functions

    case "\$1" in
    start)
        log_daemon_msg "Starting resize2fs_once" &&
        resize2fs /dev/$ROOT_PART &&
        update-rc.d resize2fs_once remove &&
        rm /etc/init.d/resize2fs_once &&
        log_end_msg \$?
        ;;
    *)
        echo "Usage: \$0 start" >&2
        exit 3
        ;;
    esac
    EOF
    chmod +x /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once defaults &&
    if [ "$INTERACTIVE" = True ]; then
        whiptail --msgbox "Root partition has been resized.\nThe filesystem will be enlarged upon the next reboo
        t" 20 60 2
    fi
}

do_expand_rootfs
