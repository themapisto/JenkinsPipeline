# vcenter 디스크 추가 
# 재부팅
# lsblk 현재 상태 확인
# 파티션 , 마운트 포인트 확인





# fdisk -l
## fdisk 로 파티션 만들기 

fdisk -l
fdisk /dev/sda
n
3
default
+100GB
p
w

### fdisk /dev/sda3
### n ( 파티션 만들기 )
### Partition number (3)
### First sector (default)
### End sector (+100GB) 

# p (확인)
# w (저장)


# 파일시스템 생성 명령어 mkfs.ext4
mkfs.ext4 /dev/sda3

# filesystem 생성됨 
# 마운트
mkdir /mnt/ftpstorage
mount /dev/sda3 /mnt/ftpstorage
# 확인 
