ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �TTY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(����o��G����Q��B�v$��%uT�j�I�Ё���X�)ʆVG���FQ xc�ZC����H��#]j�5?�D�-��=ZTЊ��C������n� ���
�¬���I�;�e�-�;}�T!W,T��Q����f��w^ ��/ h֥��]���*U����Az�M�.�,U�_S�è6��	)�cPn�+s�h�eK5qq��I:l�M� D/�;}{��Vq�`E�F�-	7�r��l�0��ڂF�A)�3kX
�Ш@�o���H�mK�T4,S^�D��ax&�L�Yk	�g葤C!oGh���!�{���1�ղ�l����G1diL�]R�tQ.K�D�F�
�� �p�.F�0�L�j��6����v�qqL�@�&ut��\`qҴyD��#�؋Aֲ��JV%mF�*"���~��;1=ڡR�|�]�j���/:]�:!�Ǔ���g�tI닜Aw��R�-���R`'��?��;/O�����?�sQ>����� ��)��?��(Y����	*l7o[����g9�?E��?�Mĸ�B��<�*RS�HM���m�-��S +䏢ZX��wI��yT)�S������믁�U�W�H3$4����C�?`����qw�+�������q��7%�-��Ƕ��I�����ò|�����a�O,�.���_��vt0����0
f�Q7tض5Z�B�l� ����<�pH�B��nXh5ց�ab��?m�m��<LK�H�ѱڐIm�iXCF[Se�ۤF�M�܈�C�?�rN'5C>��ZL�kL�bhm\%/)�z5��V��0�K�B��"�qq�:a&$ifS
��>��X؄��-��j�0���55�6s��Z[Ք�d�M�CH�m�����X ��@�|�j����`LRx4�zI5�U7��|c��z؋Y�駉�ʒ������5�?A��dw�*���c��7 �Q�X�����`-��:1��)9�D�4"�-�2:B`�u]���6�'��|��zGQEv��S�!`� t��R���&�,� �Z4޾�Y�HB@�i z���P���� |�}"h�F���aK�[���L�UT87X�,����2�d��i��Z�dBu\�n���`��]H6�B���b.
i��%�6��o�n2�n��V1���6�T�+��}����	z�8Fl3nf��$�M��^�,���Qd�Z�4J��=tn� f0��c��V��k�eEٕڪCa�}��&j(�*V��tQ���5(;��T�&0�v�4�~��O� _�ؐ�Z����4.�~Fy�t��ۼ��-�^""�]5\���۩�xFX�% 5J'/_^"��#�M�r4!��3��¡-ɔb�p19�0f�ǃ��l?f�����b�7X�>n���}yGeL�o��?����\)}i~q53��@L3H�ӆ�<��Y�FSX��XR�U�ږ�s@Ri>�գ�����	U��V�*�r�X]��&�%c��=������ _,c���:G,gSG�b��-䟟]\�̞�;� T�u:/��n�[� ��a�%0�`�sС�fë�D9����(D,^���[�
��Q5�;ի�@G;˃�6D����F�0�z���:`�Ђ��?{ÄV�>B���_�7o�����<� x����X^I��#5\z�U����{ITR�ⴸM&Tt�A�fE��:�8ϊ���B�G��Lbc俌V��<ϸ��3��X����q����d9w� ���Q���1f������M��Ǻ���:D�@(dZ�����<�2�	�f��Թ5���!}��e����`≅��<`r����bL��^��?�,������s��I�����?H
���������Wᆎ���� hY�����;ކh�%���
<;���76 �l+ͶCv�Hޣ;��6�c����^C�.e�<#Ձ�,D#��Fw��9KL�n�"��U�F��t���b���j;��鮣}���kpy^�O�QV��:�y$���<��#޹/Y䛱�.� ������o�<���Q����>T��#�m����\��$�8ƹ�]炾�&N<��1FuŞ�ď�f�L?.j�D�c���|�3=��|[x�����?O,�.�^��=���х)`���ˢ�Ή�2s������g���?�<���>t�渙����~�0=��|[p��GtD���������������@ �3�ˬ�TR��[��9#	�,9��o�X� ��J�%
94GyGj���ƴ vy���Y����C3dIk��}��r�Z�\��ٮ]���]!���f!'^�o�~���ۓT���'Ƣ��G�;�	F�(��.(Ԧ}���⏣� kJ6�A�{��#�#dd�H��G�q�0��gXݞ��	������[��y�'�����s��7.�;�B`K*"���K��
q$s�N�sI�\)年R���y!�-���1O ���\O���bȕSˁ�H�`�C�`H�H��q�@�P���X>��X�;�BZ���*!7���C5I�|u���gH
G:��ں�Ga�	&�.d2�|�h[����br'3Rp6��Zd$���=Q�1a�ŝ2�:�ve����)g���xB����j�mWGCU�B?�bu=��7[��q۬U���'~�5 �M����Ah�%�C��sɸ�;��nA?�q]�6.��a��M݂&��c�a���p!�����荮ŏ�
�;��z�L�(��B!r��� ��^�v�o5S�&VY��|�)|������+�X���+�Eo�,v}2O�]�O��쭼���� 翣q��7����L����n�����(Z ,��<�C�����)�s��(�f�E��$p<��e<;8�z<���M�.�u�^^	�k�� ����+���c徇�������p�������/s�W���l�׸�pՠ#MJ%K7H#C�3{2����g��R������os)�$���r|t���\��_�OV�-U-��t@�'B��/��Z'��<�����
���K$��?��¹X�_�������r�ô^��:�Y@Ɇ�s������^�=�>�A0�%�c��ώ|3�}��jq&G�y'�'��̌}���R
�§���W6�\��V��W�m��%�������)C}"e�k��d�{(C���B�u��_b�[;׽[s�k5�Wy�W��7q�nء<�61����Ș���l"�x�c.0s���n�2f��(��������i�2&��ph��X�[�s�w�$xw���T��3m�q<������h�Q%��w�B�k�Y���p�C�w��6�j,Kt/��PV�:_�'XB�V�bR=
��j��V�h\��1��*�xmu�c ��VX.Z��r�U8���P���фbl!�xA��rԺ*���������AJ,W�ٔPI衞�fS[ǩ��dB7��Rv����ꯊ����Uo�L�\�J6�͓�B�TJ��n�dw�Ti?�[*e��ݝs��CE	쎘J�J܆-�t�o�WŽ\�D�g����Ί�C}�?�^�k��A.)����R-�J�Uxf69s�m��Z�G8sq�`	p�˜��&w�=��|�@Ba=7L��r��Ź�*���&�����Vs�\Wtk��fz��<h��j-��+�w7�)v���^�q���W�Z+o�\��+�t7���t� y�a��I��|��ڍ���Zf��ϭ:�������<Է����1�J�Y�;-��t�!��v�R�8I�Ok���w��+�[{�����F���N꛻��h%����I�+G��D<�s�Z����3zP���Ru>.�O�[���Ws��n Z�L�PJ���������%s���W�R.'�T������ɜ�%qbWLF��TN�[������9N�Jݬ!4������SV�Z��5W[9�l�^����+\��K'���2���[�C�[Dc1]�
ݲ�m���-c��h�2����J5���hl�rR_I�ڪ|Z3&�M��C}�\*�L��*�h�s�zv�ѱ��H�z�s�ɜ3�H�P'l ��cX�����o9����H8��mCol����k��D��˰��0�.� U ���������o�sޤ��S���w۹;�_t��/`>�?A�g�����e���O�N\,gwѤ��}���e3�BC����f*��*����+n&3LW��r�Ԩ0���`5)�:��^��e���ʫ�v�X��}Y�{��T~��k��|JJ����+���p;�tR�ʦQ��Al��Ǌ���U^7�[<U�rf;y�\�t,����{�rEWN��\�UDGz`�-E�G��ьV�[�Ác������b�����߮�w���Ø��q����7��;��l*8�{���cQ}������zp��[�3󿿟vΦ,c�'X~���-��P���zG�}���}������C�s����)�e^�+</�#���`MQx.!ţ2��l���uI��u���yF�8�_YY�`��_�C�7��-�y�/�����_�b�/?}����f^,��!�7��B�
KϨ���a��j�K_.���q�jp�Jq���%?��)*e�a9j���gKK��Hp��?}��W�fy��'��@I����K_,��g�.Q��_<Dq?޳T��ҟ,=B���8��ԁ8/�/�i^
Q~�U��w�������G�ۇ����<=�]���^��HNۂ�������k &��������/��i�5��-S��]J�OD:�g��>�?�C�<3z�?��&%a/��t���L�A9&aE,�e��P����� 8)��S��.�{�:�B���DJ�V]mD$Z��pa��O`o��$�o#%���8I��UJ|F�z<^�eXg�D��$�E�V9�V��W�R,�%..�' Ts]����f�����s��H��/{b!�(��9��H�"����]I���u�ēIgz<Q0�+�ә$�3�D�j���&J�(��(Q94�U���T�t�C	$#��G'd�$�þ �r�{��'��TU��j��RyZ���j�q����{���#���f5�������s򖼈h���)��O��x��^�e��V%��b���
+��aòW�i��b�����UˈG�������,�J��<Z�^��/��,��8���8��
?r����Gz�����D��X	�G������;I��x�~8W���@䏺��yl����A8�w�pd��;�L�mN֙˜���ϭ���ۄ{)ޛ�z<bg�ή��-�.��5p�;	n�-�<?DO�������G��wuU�Io�\vc��7F���������W,��}.\�6oI�C/��Ѥ�g�����sB��Y��U���0go{f�.��-L�t��/r5R)l_�ɳ�[N=F��,ɵ]����O�~j���%�Bk��$�Ш�Z-�����a<�k׉g1~��k��G���i!vk\I�qOS<1�G��Y褥�
�N�ܘj�J���+Tee94�+�ҨJ����c����۹9d.>WVH�]�fH��H�}D'�Xu	?]���Z�t���Q>.��rD��y6�u�I^�����-f��^��p+���3��d�4�"�=Y4Ϯ�� ��n:�� �~�š��_�_Lkh��qlx��6#f��h)	�m����l�+��q"q�b�%�q]*?���՟�.{1=��	�G�~
����������G�|>���}��Vx����?�����W���?�����w���w?��|����{��M:�ou�Gu�u`���Ko�t���?~5�����.��k~�cGu۰�0t��rY܄�v�ng�V6�¦���@<k`h��ؑ%P+� l�z�0�n]�����W����?���������_��W?�����������'%�;��N�ea������-Q�?��wNc|����|>���N������uz���\�$��2CӤ��Kdm����q!4�>���q���J݌�-�]f�vZU�);'�e�����JG�z}-M�v�����0j|̥8���'қk1���d����Zsv�jv:z�
[2����#,x�-LQ�cTň*Lq&(�H��H#��[|�|�Q��8�$�H2�o��lg�Z�%��P���.�f���\�@�U�l:5n��%'r�yRnτ��A3�6;h�'gHƆ�^�?%�!!iF@��B�d����k+�@ 3��_f����95��V2��β)R���M��(��S�����$P�M��B2Iα@w�tD��i��&��,�X9 ���:�W	Ӟn��XYO��@*�n�;���T�$C�I�%GDY�5D�[	���S��6�+.8/QR��CEb��O�t����8|��G�Ё����]-�c3��}�(?��G!�n�m,�ԧ/_��(=YU�\UQ|0�l� v�JI,!������B���D^�Q�c��+���<R$6b�U.:ى�VC�)�T1א"�d3Hm� �C�CH
�1���՜\��c:����Ӱc�a)���Qg�t#G�I�wd6�tV��� ,Ҟ�Qu�*�'�RK��&Er�>/AU���|^�OD	�Z5P�PaƜ�&�
�b��b$j�&�3��]d��|�%hrH���Er¥����JM���Q>���!��M��*s�l��m��D���,%Üt�Vf~d�R�By�^)7h��+�"�x�%b�x�Saa���\rJ�����N������>0�e�J� %Q�;�jG4�̊Ơ��Ԅ��mx05�%��A��S�2߁�� ��zk8����?���bOP�f���Q�^\TIyЫm�9�3�
Ka�!�9E%|���#�(m?W	�&\�W2l�/tHx!,��ݬcAa�N�L��*�f�z_l�Qî"x�ҙ��&�˄�O���7)�nZ�ܴ��ip�2�U<�M�x���� 7-�nZ�ܴ��n��%��zxY.�H��7����߃N��=��/��I�^��������l^���3�����_���v½���C8�����nr�S���7N������-��O量~/�'�N^m�K�s�{E%�c)��4F>�����x�}����u���khR�ה&���Ү\�	p��[-Ug���X�<(hT�2�gkR(V��b�7G�a[�p�L]�i�����4f����|�;�)j���i��z0�&׃��+d#Zmj�vXAs���^��w�t)��~E�"@�kx��}U�f?[��&ݑҩ��:q���N�i6\o�f^&��eBɵ�`  <��%�A��X�s
�~_�jB��6�\)㖘���+�q�b7��=���s��	G����Sf�6�_^��Z:Q�#�؁e3"��#aL��ˍ#��Wi	���z���]S��z��^��*V��*�R2CHCS�5�\=�{��	ͩ��Ə��\�b��R3�1�̌V�v�&���p����8��"]d	P+VӪ���_7_�TA.��|��e*MW�J�Sxn*yR�<��E���Cx�^f��I�����k�Ro�^?�|���YΟx���>�\|�o���t�' �i�@�>8���������<H}����߾b*��g���HU�q�ri(=)�."�L���[޳V�y���7��[����r����U�'�N���
�4���*�ڣ�돶B�c_2A��y���J���x�S (*J��$93����@���Dź��]���=g0A=M�F��5|�S*[�Bm�鞊�|���"�s���G�QkNV�q 
"�Ա����"n���(*v�I�M�&�x�#���z!6���)	<Y��!Ɲ99\(m1�����-��k��E�my��S�#��#�=p#s^�90I,v�2VvfY��4��2�B���5E�z�4u@�f�C\�͝Ճ",*,=�� �FEn�݊^�1?@�v���.��|��x���gɽ4^���d ���z趚��M�0��X_ C�c�%������(~�\��Ou�t5̀:�+-�3��`���y1��/��\4c�߀���G�.�K�T����B^m�U���,nB����( ����zD��BDtBk*	�F�dż�8�l�MD��tYRfӡ�Mך����V��5�rWS;�	�[5{[u���uW:����F>�n����0~T�U�4�'��.��>��]��>�~�c�����s�U���}��3����w��{��+!���Q]�`��&���!�2Fo�Z��gw�#�<g�Ù�FT���� t��(O�p�`���c�57ʺ=o���T<f�J�&��V�z���~c���X�3eH:�jͣ�-���c�\�bHe���u$֑���X����h�,V�1֢�t���z�W���]溣q�Њu��(�,Y�ꦇh�kC��l�H�B]�Kg��1R���Aܫ�T�+�*m)l���QS!]�	 ĕ�Cm�V����*�-U3E�t$��H�}���L�4��A�K/�ע�o�^_�쭟t���I�I���D4��UDS����]4=Sǌ���Kr�A8	���J��zx9�{��i��T{ltdwn��J�v ���'߃����k�y}��,�v�~>�s��"�?�����逽s�x��x|�9WM��s<F>��2�*��U�=�\�8_t���zx3��w��=Ǐ�:�T*�������/.�ʹ���	�x41�����$�/������!Msd���~-u����/)�z�q��?��s˟�����z�ĵ�����3��������o��l���?
!���۠g>�eSO3�(
�������0x�����w�����Vs��sO��6��)�G�=����G �<�cYt���A�����������=���at��{���1�/:�%����nh��{��9�c�f����m����Ŏ���M��@}F������p&^��������Q�E��>
w��®W��;a��[⿙��w�c��h���������;���}�Ǯ��������C�M����[�}?�]���|���zI?�	����������ڱ����r�!�������������mН����8�s����g0|������m�U�yс�?����`X�PG^i`3nH[(��g��ן��ot��7��<rr��\���j���3x��nA���z��)�jx��E�i39�ob~��U��2y�IU�t�( FvC)����tG��Gy��(���(|q<��#>7�����s}P�Na���?ꎏ��Ɛ��Rpq� �.�8?�+<���Χ����EM��M����x0�Eh"�FZ�k��&J���kAsr�f�ՠ�\-� -�Z��(�^�Ϟ��o�X���A;����,�#k�������m���G��������3g����b���8�[����t���%��\�q=���X7�6l���%��m����������۠5��&��ӹϳڱ��b���l��⠨��D�I���\���B�@,F �X�Y�Bэެ2'���L^ "���l��Q�c'�S8��ff�� �!�����wfM�jY~�W��-��� ����L�t0�8�������{�^�5u%�D��"�L*#���^���"�tS��m��,���ڝ���g��;5n�y}��C����Z��7������??�a���^����4q������&�B��I�)��n�F�Vu��)�������?����a��a�����{��/��4����(�9A���c2��y>O�,�R!�������N�<�%>bY1�h>���������� ��~e�_X�1Î�{�"Ѥ�"���6�h��_��Џz�V�u�O��=��Q����®˵{eB���.nh�Ă<,�*�d.�.����<�z�l'�B�]���A�%j�B�Zh���_E���^px�S�s�����Fx{��T%, `K��g��,���X�?���hF�!�W@�A�Q�?M�����и�C�7V4��?���r��k����o����o������B�����+���w����ӯ����w#4��O��������O���������J����?���/��O���M�MY����!�j�a�Z�c���ks��G�V������Z!�͵V��',/jb�{�����1�lr5iw�hٳ��T�e�0�\&�c���cG�gI1ܵ/���9�c)��u��Qخ�Y�Ok��p��tEk�h�%(�Sx��J�Ko�7��1�|w��GKo�cE	�n׺�,��g���m+�H=�N$n�l�6��#+4�H���������jw��E�J�����ʎ�`6Ի�7�����4Q:Vi'�iu���9���H)�x4�;;�s,�.T^-]{_�W .����
���~����{���~9� ��`���������������N�P�A�o���~Q��{�����;���!�OƎ�]z�Jڶ��攗�&�d��<�Թ��������d���?4d�ny�pg�5'6��c�?�Z�^����IN�i�';��������r�?��zVV������۩�Y����Nr+Ql�'�����pc.d�C��z����J�(�`���@�k��~>���hqI�#ϡ�������x�@E3��+0���?��EG��+@x�����t����������������O#����T=�)��	�����3����8�?M���d@���)�w�SO��X@�?�?r���g�@�� ��C0 b@�A���?�b���F�G�aeM�����q������������?�"��������?P�����G����������������CP���`Ā�����j��?46�����18��������F���>�j����Yo�uf���Cۣ�@9P�o���_��sS!?��^0Z'EW���'���qu��ړ4��qb�O����4~�v��2$"c4(za��b=5�5=:T������aW-�2������-g�v0Ɋ�P�->��������W���Kko~i��B��N��2�Vfǐ�F�x�ycV�r�RҦm
�����:���_j�~���4KeUϡTG_���K�BZ�D�&��)�0�sq(�A���	���`pX\� ��c���iK��씳�c6K�Q$O�C�}e�aQ�Q/���k���*�V��!�������A��W�������(r��#Q����Aq)-�"�%yLQɊ�$�<%�l�Ͳ+I�(0������{���3w����<��&���O�ww:�2����{wש|m�Y��:z�,k��ǆW,�����M I�`�v�bF
]1j�w��dl,�<�Ȳ�u�U�U7����jC����[�=.Ǆ�X�7��p��o�!�ޔAZD��ު����arN�ta�mXӻ�5�N�?-�ӛB��c���@GS�����?���?�?t`�����������G�����|�FP�����A����?����@���?��@���]�a�����L��?"���o����?�����A�������?,��?������ � o����g����7����Q<�?�����{�;{����ϸ�����́ݍ��7��q~�f��1Ώk���[���M&͢1�:�΢�k׏���fv�ѹɃ��p*���i����m���TC�R�6�5ެ��]���zZMMC���v��7�2�Gg�������L��T���g�\��}��u�����j�{ħ�JG����s�ZsYSO#'�>N�z^ׁ�3�3[�t�gj�:D�c;�A1�n�,뤽
<�ނ���
�-��عu:9�'��ps�����Z��R��{��g��]��MX��1���e����b����i{S�k�U��]
�c���<�-��ȯ�{*s����X��{����ɡ�g.Z9��f�GS���UR�Z�m�?����3�Sh��6]B:tC_w)�Y�.�R��K���UnJ��5)��y�שAޤK�=WN�b�ߪ��Y��B���������?������Ā�������E�%��S^��,K�f���"^��H�>Ix�&�4�cI�Ɍ�sV�h&O�$�R:� ����A�!��2��!�-?�*{N]�-��n><����)҈����<�[��S��5f�A�[]iw�V����Q{�Ug�Kp��~��N��S;чʭ��χr:��(��lg�������w�k��v	���[����x����!i��� ���z��������K`yW���?��i��	p���BGS��������@
�?�?r���/d ���B�?�?r��������ۃ����BH� ps4��?:��0���?:�+��e�����ʂ/Jv9P���.�g���"L��?5���w�s�t���Pr�~���;��������Y�Z�^���m�u��T��;6]�]wH�ej����x�o9�k�(Omm��-=H+���ej_�Pr�n�z�\�@���>���J�y�q"�a�ߏ�5U��>8�%���\���;}M�o��h}�wn:�9�X�9�Լ��*v,ce��{0��|��C�*���������B�!���?�~D���_�14��&����o��3Lo0]d������N�K"���O���E��}��A���;��]8�0�h-�jR��f^�n&�q����e����b�;�emne4=�ֵ&��DH�����W��-�t���R���N�����&n���k�7��T��mxɻ��1R���ՓUE��
����c�Dx�j��x�q�n�^��j�:Ln/���Ӽ?�
y���2�}-�:�땚Z��l�[�6���v�i[��]X�������!���������B6�����18����� ��	�������������a��L�e�G�ԩ�P�M����n*�go�'��N
��5�O|��w�|/��U/gF=v�/�d�R�],_�|�5�b�`΃a�/�	��ܦ �nN��q��^�hd�zzY��\M�diZ׭S��2�l�/<~ww7�=��q��Kko~i��B��N���ү���1���1�vy�8i�#iFF���7�T���t[5�S��{�x���=���\65�ӷ:tw"u|�ksim�m��=C�!�h�3��M����EZ��D�e,s"�5��s��>?�֭*��ݢԒ�DWvN�oc��,�?��B�����}�8�?����D���c9�J�T��!�"���Ld������GOg�0��sA�!����A�_�1p�W#����b�:�2Q]�GqXv�*\����`qv���n�5 ?���ݝZ���H7�50�^Om�f{�6��!H�6�Nw�pu.�}�k<�I�%����k��l��&���)�#c��%	�_���域�0��o��I�_���?��H�_`������7B#����Ҕ����7E��k����o����o�������?�gS�#�L�s)RQ�$�9)�".e��Ĝc��cy�.��L�<�3h�8��W�
��W����yS8���$���3j=�c�3ٖ+�n������\�d����u��S��ۻ��,F�}ϯ��%.���u�G�t#cM=�\�<�*�y%,�YWS���<[]�U-��j�w�����������	�_������JX ��&�����Y8�����_Qь�C�7��������~����q���o�hJ�4�����!��!����/��P�5B3��|�
���]���p�:��������5��r��� �a��a���?�����b�q�����p�8�M�?t �������������G��翢������MQ�O�5M�������F�A�i���?��M���x,�����S̳���M�X�ac0b@�A���?��������A4��?�����_#����������/����11���w�����0��
L��?"���o����?������6#�������8���?�#��*�����F��o����o��F��_���?6��o�]���G���]����b��#��\$�L�&q�g	��Y��"q�0�L�&I*�� H\�%�fB.�"+����������Գ������?�����������_��sM��J���u��X�\J��ʏ���wemj�[��_�~Υ���E_0����p�������[k8�DO��� �w]�I"��Z.�z��ko�����ChxR�����bd��*�zM���?�tV�Yv�Փ��ϜE�^z�h#N19}���4��z;�QY#��VqF��n_�b<���4v>�CM׋i�S�����{Rm��C�� ��=4u�_\EA�G�Ѕ�?�����?ZC���?Z�����?��h�������������?`�������Z� ��e ����_'������?0�-���������?�� �����h��n��	����3���p����O���S��M����˷��d��&E����?[ᴗ�&�������̳��7�?��Z��rPm5�<�>����K�����b�g�$ANߌ�K�Ɓ=[�SL���"��"f�H��Ζ�W���s�RF������um�bU����l]��pe�k�`�"�W�奜��M
�	�Bsf�#�%I]9Z����&����cv���i�ٙ>1=�b��oc�?�N�?���Z� ��e ����_�������)�Oz��8�tQ��.�Gd�`}/�#��~��]!\4�B*�Ⱦ�G(���5t��A�G{����<�e���]'?:;�I�)Nitp8�,�Q��`�L�~�y��б�k)�3�Ƙ�/�<Lx�J�m#��>�����o�ck4��9m��8��"�b�d�Y����`�9�,���+���Q����|���)������B�(�M�O���|���G	��7�?���.�+�?���o]�A��?��������dah�
�t�G8��}"�i7�G�O�1ϣ����P��C��H������X�?�&��_�4���~��S��E	��jz�HpfA��L����c�c��������5�Q��1>��ՖY�����1����!���E ����q���j,��pv�����y�!guBn��"e����Qt����w����!4������h�����/�~���{�_�p��*����iU0G'��A6LDy7�夿{�k �����}�,�k�?7V�u�ϖ/�{�$���������-_Лom��[{iY[(��eM�~R͚�s����κ���N��}u�OЯ��j��No�4Ԙ�Q-V�Y׮%��1l�q�Zdm��{������q�bxՅ�P?]3���A���[S؅�=�~i�8���*�u6�$l	�T�Z0��aJ�8`�)^
i�Y|�W����}��I9>ө�Y4!S	�a����b憽���҃t�X��Q~
����x4ߒ�j;�n�ޏ��=JTO��y�]�^\}�^�?���r���M ���	tB�S�?�hM|�A�ow������C�����uM������ �������ǟ���1��spʌ�l	��>��?��g����Zb_g��;�?��3�g��E�p�f���N`Z츱�3��e/*FiZ��A�T5���_2e
frhy�Y�7�VD3#�y�-to�b��r�8�A.����c!
�3�oc|��1>lʲ�m��EF��)��M��t�!t���岘�g*�E����c���k*Y����y���9?4!>��?�b�Ox�GWg�Ɖ0�.SH�{��Kד/��MXj���$�vv5�%M`�"Cf�O��$�
�7�;n��y��w�C������ ��4q�!�����[�u����oM����o�}�u	����G����	���9����ɳ�����;�/^D]a��6����.s�gO��?�v�λV�Y��b���;�������Ɓ�WfW5�X�y~��>�w;G���d7�0��&d�"�oL�^��=�O�>�������/�W�6�c��k|�2��<�DS] T�S3�^�4^�mF
k�|/�j�s���L9��r�tTwf���9H*�p�-���1��V8����o�}���WC_������?^�
��wv��[&KG��6.��$��,�3���������KO�->��CCc�T�hF�D��?:��
����V��~����������k������dgX���a��e�����#��.����#��.���'�=��'�`�o̹�3i'���7C� �g��f�Yܔ����g���Mz�+ƚ�%�d���嬌&��Ov�^4���Od�A�s�7I��=5r��)D�")�	){=x]�#*q��?�X�ܴm��<� 3��.N��\l2O�˘��2>*纐�sF�G|��!��d�*+dʇ^��uD�P��B����#�h����?��1 �������_`�W{��A���iM�?P������A���	�W���[�7�a�w��c�k��X2g9^C�"�Oր���ܐ�VWe�����ԁ�x���+����-�iO�=��:�{<�O� �|ڒ�_4ߪ���N
'�C��Ɍ�JEe`./&�?W�M7;�$�fg+<��U�te~W~��ѵ�}c�KX�7�X0����3��l#um;D���z˙m�� �8�h{�7S���A	�j9���|⺦�Ir����)I��0a8��6��tC�=����A[�h�n���A�M���F �@�����O��`��5�Z���������?<�!������;ǘ�[σx��2U��I]�4�f>�k�%Fͨ��%��ۡhr������,g��f�Y�d�����&gw���7��s?V[+f�\O$E�f4Q��L�خgw�~�]�͵�r�c�'X�Z�p����������E�00r����卲bѧ���%Z.�b��O��������b�9fmES�����x6����o��wU{`�KKh��_&1��(@����]����o	��?� u]�����@��@��Z������@�5�?}�?��/����Wh���y�O ��7�N�?}��I!��&��߭} w�� �?����C���_�h���N�n �?�������	�����-�)����ߕ�A����������������`'\7 �������A���5�����v����������0��_���w��n��	����h���� ����1����{�x������'�_9��H�摀�*�H��?��������y-�/�f܀s$t�e܇�9A_��dQ&��'�<��;n,�挧|ً�Q�VyyP"UM�����Lك��Z�bF㍵�́ǈu�oݛ�Xj�\�`�� ����7� <mYz��Iy�ƉMYV���x�L�'�hZT���S��/��t=S),��l_m{�H��XS�zn��k|V5~$f)��!��R��0��`*]8�������'_��9���L�I���j�K���E8��H�#I�|olw�^���3����	��<�󿍠-������!�����ϭ�������`�s#h��È	&���"'(�p���T�')��0�i:
���c��~H!J�]����O��~
t��q
����&������yu?_&������Պr?J��$�vog�O�6�R]�͊#`(vl��#D��]L��	���ܕ����F��Qleb�Je{�������>l!édDЮ,���ܮ)t��<����z�
=7qֻ��H�9�Ie�9V�ں�'���1t����w������@���h��������5�N�?M��?��h����o�!P����m�?�>����F�*��������O�����φ��]���)����O����������������A���@���?������?��M��lk��������7���@��j���`��n��?�:�������O����O�#���Qp�:�����;x��������_�ĸ�J��9k�65�<�o���o��u-�~k'��o���1��滧0Ȯ�����<�=��������"�lN8i�y/���)���ѐ��9e)A�\�k#y����1��3����1YJ�aWcZ����k������ӥPEbk!~�쳛e�XM`c+�u%@���XӔ�})��b��ׇ����/>7��ՑO�}��Z}��O�����Ň�YDm��6kႨ���e����r�1M��D���N��#��rj\���+	�'��M��8�Cb����.q�����e��#tB�!4��l	��?�:�������������o#����KD���Fh��H��"��T�$�Q>�F7]0d��~?�Q�b�H�!P��.���������7�ߙ��}�8Ro��8@�}ʶ6�ψU�۰ʢ�T�g�^����F�q�R
s�H�G�(w���KfP�#�x4]�dt^�39"���v�7�=��
��ı���TcG����?}���>%��鑿�����|�Q�����hp����_��la�-W�/�)����/Q�/�/�~�����n�l�/�z����w�AeX}���x�7�������cg��lg���\vgz%\-3ӽ�$vb�)�_y9�ï<*48~�Nb;q'Y�4?��j)���"�'t%J[+*U[ď
K��@�_��HH+;�77�5sg;�P��J7�9�9>��=�����vl��c�x8�CL��jh�g�.�ww^�S�X�V8J_�_&	!O�H<�|"����>��q#�Zx�
M^;xege| �\��o��nǑ�q�������;m;�b���9%���c���{�f���R$b#7����rT%��5���cAGwbñ�X��)���>9f��X��S��bY���=A$x�X���$��՞2����m}�k@W;n셗O�}�=]�N�GG�p���QG���%����4�CUx�^�a�{�
E�8�Z���v�`�ET��-䪄���Gj�s@�x��� ꆽ�� wb��w��/��S�c���N�D~<�@��j�?���챑,�+�i|�vg4�Qt-�A�/u�Nw>�������> ŝv/s$Kwޝ��:9�-�X�a��i��?�&P8�	8���/ �q��[�/n}��?��ڹ�b�_�q]E5CCQUO%Ԍ�F����4I+XRE����SpR5��j��%T\O��c8���Q��E����4?�������g��/��Ͽ��q��yppS�}\&<�g����]O�b��2=��^|�M.9B�i����B�*,��t�+��>w���ֹC����6���B�
=�u�߯�랪�P��гЕ��Ҫ ��uE;T�W��^g0t��&��������>�ɷο�����~G�6���Ε�x��]���?
�P��wL��}�_*���c�M��#��O �l�.�t�����}��[�J�������7�|���ٱ?�ԾFAߓ�w%�f�[箞u�߿��#���k9���K�lj�1T����L�`CIJJ�ө$���6�D),�����hO�)I��%����K��귕��ܟ|�w�_��?�.�������Q��A�>y\>z��'Hѿހ�q�@ƿrm��σ��o=�����T~�����B��cq��zB
	z�(�kZ�v��8�J?�8xN$�qp&������H����' ��Z�D5(Ӆ'Ζ�zTf/ʂU�M������瘠(KsF�BzE�E�[C��RoM�>�5E�Α��#O���dǠ��f�:j+��ݞ3-�T��;\-|v�У��+b����H�o�_�/Yh2Ah�y�/�%ͬ�<:˛����2��\51c�~����Ipߞ�Gx]����P)�U�`9�b=�؊H:'l�'=�h-���al�F�|tM�#���I����;Gu��5��(���2e�4 �n�hM�\3���X��ލ�|�{�Co@�/��C�R�j"m0@��AE����TV���"�gJɂ/�]tq�*P<�h���!�uJo��f`��p���<��҄�k�C�=��"ۑT��R���r�<&A̜�9_2BԜ�S��&V<���v�����e6!r�޶��$��V]��W�g�"�h�j�R+�[��C��A$J��P�GT��R���%M{�����l���n`r~|�Kf;��#�{Y �([���M ���hFLA����-*$�d���|\�a�U�ל8	��('(����q����_hr�BE>��w�88n�$8F�
�8��Β�L�A�p|���ɖG���h�r�t����ш��'�<^��ݩ��OT��I�k�Kuʭ��B�@lK��xP�Ż�,�cb����""�J�Y�̶�%l�Y�gi��U�|M���lT����N���15o+�3�h��U��g�z��$��r���f��Gc���d��csS���8�Ʉ���ǘ��!�S�%?L4֘&yl����^����f$��q.�)���:�`���hH� �%�d&�l%g�a�_k�Aݨ X�ܙ��G惘e絇�k֎�����u� װ�Dv�Ux�B���A�����΁��Ev�8�.�Ǒ%�͟��$�w��֓�8_r�����6!��iyl�h"�z=.�l�,�Z/gACȳ�I�=[��]�A�����!�:R��5��&�N��mI򒭊0�(��r�ԟ`��<6p4��Q���z"�k!�r�`]�zU�����$��wX����JW��}w���~"O�63`]vN�j���Y��&�sl����B����˨���HP��ת^">)&G=�M�3S;;�]�qe�Г�$7O���xR�t1��b�{Kѝ��R����W�נ-�b�y~�����uoz�j��7��?����ڂ:Z!�dM|��쯔�{�`M��g��~e9y�
��+�]9�|�䝟��W��|Q��b0!���%�"�:~��{1y/�e�~�6y��2y?�tKJ�M�A& gg�]K�f�ۭ�ܦ���H��Ġ^��MWy�VA:�!���6�{�8�SR��4� ���X�1r��x�{1y's�,U���n4{�u-׃�Ŗ�D=$msjd��_Nf��'��p��D�U��-| ��&�n_n�,���V��ݡؑ��T�f��m�욍��auF�
�${���M�C�\��(�q��=fK�f~���z���t�SV�~_L�C�qib�!}@M쩩�4���\�L7��I�%�a0���֤V+H���+c�t��	��Z����D��+�^V42sK������K�黎廰L��㎃5?	;���z3#Y��s\c�6��0��M,�rjTŽ��r�J����H��Ac�y�,>�M��a�@�rYo��ޔw%Mt�B�"�`��"��r�j�E�̿k&yT����`b���9j�u_�-ש�=K�A�COo]����r���F��n��"&��.��[ �}������ͥ�~�&�7���<T���������'6�O��/��C�%jd�y������AP
��j{ r�<����.�&F��Ngw���$X�����'�U٥��8R(���x�[�穩�E5]Ϲ�6?���Q�_��A��.���T6��	�.+7�r�oB�Jw<�)����x>�;�>�9��d�$\p�L�=�I��7LZ������Ն�Ȗ{�VʲE9`�R�)w\�[U�	gu��,�.?n��bs8tYE�i=�����+(j7i���n�L��s��K�M�c���9~j�o����7ު�0o�&z���=z�����ͯ^l~���W/Nue&�����n���׼��@O�{����?��Y�@��f�����=�&�����.v$B[��ۿ�D9���}q���U�"x�w{��A��%R�����s��-p���o���ߏ�u��G���;A?=>�����W��s@�kG���q��s�H6��>9��F^��%��]Y�Y�2����V����v�c9&�3��Ӈ���{��o�Y�M+#e��0��E�qH�����
W���iC��uz��Oۻ�؉q¯���X�m`��6��l`��6��ȇV � 