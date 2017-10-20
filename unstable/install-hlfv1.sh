ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
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
WORKDIR="$(pwd)/composer-data"
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
docker pull hyperledger/composer-playground:0.14.2
docker tag hyperledger/composer-playground:0.14.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

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
� '��Y �=�r�Hv��d3A�IJ��&��;ckl� �����*Z"%^$Y���&�$!�hR��[�����7�y�w���x/�%�3c��l�>};�n�>԰�DV@ŭ6�Q�m�^�®�{-����@ ���pL��S�B��cR8&F%�'Fâ����BpmZ <r,����x˞�J��,[��6x&=�8Y]E�6���M>�o�uYL�B�ç�ނuR�赑e ������K1�6��#	@ <���m��+CfG���B�3@J���҇�A!��n�� \?Q�Uhi6��N����5�@�2�a�SB�ė�\2��	��"d)ZK7��iaà+#�B�X8��өE�H%��4��ݤ1ـ��w.���O��i�7L�:d�-\��x�M�FV-]]4|٪��oA�����:bPXD�!U��:�"�&�C��`�����l
�,�FVQ����]���K�9,�!����5�?�CZ�eЮ׭��
�������#؎	a��S��g��P=���&jP��V�n�R�΁U���E��b�e8����&�Wa��㗗�Ȁ?gԟ?usd�l�{Z_}t����ǖ�Rf�t�i�a�R2��N����60]ø��Q�s&r��j2���t�z�Y&4�d�v}�q��m�?x8��N�§�{o�:y�Xd��Ga��I�#��,Fb�@��{2�p�o��;��Q�kz�5h7��[����%��$,K�(�r1&Kѵ��
x�]����*���]KE������՘��UB)�~(�����>6y������ȧ�C�lf��u�f�?�}���U�Ei-������0C��Pm�:
��ؼ�6���<��O��Ȕ�G��E@7���uf`ȱ1^
��W:}4��6�@������ά�ـ��^��ܦ�b����v-�3��m[z:�k��"Vd!�\w���Ox��ox�l��%On�nbC3�(�;H�s����������Sү����Udڬm�HM$�,�&��6���czY5��Tpxj���p�ڴ#��in#��U��^{�;=����Z ZjC�0\��m��X=.�"ߣђ�H]ox(�?�����<��ꗺ�H��#8�Yx�I|�ɠ�dQ}��6����H��Cwu��y:��%A��_���@�<PsMv��t@S7 MX��;�"`������K!�V��~��]qܡ�����X�m����5�z��"� ��<޿�$M�
�����#�Qڐ4{���A�0l�?�[`�d���N�&��Ks[/�A��I�V0� P����,f���g��%��A��P؜�:�c�09o�;��[�a��x�����tО̏��ag����DdfYu�#����TE {S�M��&dl~}ti�$���]�t�cE�`�>�0!Wtu�U�}�0��sd�<���mld �݆�6 f������yΘ|�d#ޟur���1~��	�L��t�|o"�W��U��S�3<ʞn`���+ ���W�F�S-��yu���C��#���M���_*̰������������:�c%�>���a������X"��,Ŧ�_\���<?)5:��3�l���OϘv��;fa�稷��`�s�\ˢ�� ��z\*W��u�Uvs��d)wX����&�W��}Ϯ���=�C�?�]b�r��x�%Q�%?�K��A��E�6�N��m��6r^'�v[�/l��_��50YaǏ*�a��4	E�x�t��,ݩ\�o���**�|��2��h��.F�s�����kC���#F�1P��B;���V�߿xʢ�H�o߂�3��3xj!��=nI�s9��۠@\qL�UE~�^z��R ҺtN�tzB'�i%LFدχ|����i� (�$�_����U�sp�`'�G�����������[���/f������p���`�)�/���p���=�T���n�$b h[��_��'���-�Z��f����t�6�ɿ�9�#�u��
`���Ν����O���%p���KP��!�Z�p8���+����i��&ك[��ea�%h[���/D[-hjv��;� �Pk�������O��8������ef?��y�)Q𓏉�r�u��?F���Kz�E��=�A-@��H�YC�1���:����_�nł@m��^��^8����v��w읦�Uh� )qO�X5���{f�[u�b�p_=�)�э��c��"kL�V&㯃��9Sm�w&x���L�nw�j h�]���T��%(|������?�0�����������G�5W��]?DāuO�B>:#*��=��Z�����q�>��k��� Ġ���V�*2;���_߽U�UZu��������%(`��G���K��Z�W� �o5� �el�����N�A������C3?*8�`W����BK����/����ߕ�]��A^�s�����,������=��:�4�	{��0�X��$���<��ڞ� (ipn%�&I ���Ѐ?�9����D��� }�?�p�FO�E/n�.�x���)J��K6`�5��g�v�$#~2?i���c:E�D�	&�,���'���ac*5����O'˘�c��X.�ɡN%�yz�{�O�f�Y�?e^���<3|Xx��6�df]]�h@��Bd���J���b�fL}A��y���h�Oh����bL������[��H�y�)�\,k�.����B$6}�����ϕ �_s���|����������k����?�pUPeY�o�TQ�8�Uk���Gkո$K1�d�Q9^��e��H<.Vc[���l����_��	o(�����n:�_�#��m|��5o��}�qIl��rt������m,ب����j�/_M�����jD��߳\w�ƿl��7��������Dp���"�W�����c���Âq���c8~� �������Wރ��?�po����XX����'��0��M�X�����/G��Z����=�xQ���5R6�i��қ�/yX#�z�x��zj��R~����:=g˱���#(�(CXP,Z�	jl+,lն⨦��-5.KaDx"��AA˂
ŭ�W��q(ˑiBR��UD�j�Z:� �D:�+�d�T�erI��f���|.�̞'����+�\B��JJ�=0�/zZ(���71��F�������Y��\Hܮz��'�fV�҉F>y|��H_*�D�pLHU��B��5Z��k��/2�ʑ�L����3=�}g���{*����E����0p%����.��ٛF��&a��#�UI��M)���W�R����o����6�B��v�9)_�	��tB��Y�0({g��'����MOS��b6�}}|t�������%�������YGmEڧ��I>Q�F~�/�3����K��NO"��M�z����P�ݓ�IɁ'�̅�/G��8j���o:�J��d"�M�>f�y9����d���M�*BNIdݭ��DQ�6/ʕ�1���
o�ӽ��M�y8)U^'v����q�(�Nឲ��ZY�#��Y��Mmʱ���K�39��ֻ{�Jb?��d-Ho�T7�u�t�w�)%O�z��O(���r�(��MG���f>���-���D.gZ��fw����"�����D��:�K���+x82��IE�+��Q2WL��^1��L����S$o��x�$j�g/b�\�͓��q���B�\�ً�V�uO��n�t������;��q~�
z/)�c�pTRvޙ��Ӆ�1���~0������n6Hǌ�f����r�������g����Y�����>���Uwhj��=�5�h��������"���������R���>e���|.�Kl���F'�BR�X�B������z(�7����فr,��7��=1���I!���W4%�A\�����N�.J��Q�2����r+i�UT���ͣ^��E2��JY��l��G��	IPUB�#���ڭ����'sC�w}`�{�9�˰��u�Y��U�g��n�s}�~�_�e���?W���(��K���L������I�8<
I)E5U�+i�Z�L�V2��'u7d��u�[��>Ȝe��4R����8S�70V�q[���o^:��2�î�o��!��6�L)���q>ݳ�=k����LKjz=؃7���%������WO@�{���%����0@��٠�_hA�	��<L�	�{io�YnMG�6�%x1p@��^ҁU�y )T�M�EL��ꂦ~��mЂ&���'~�0��.��g���CZ�~�Sz~@; 
�GpF- ��-���`,����w۔"_n#��b!@_;�YUd�.A���@c	��7�+���Ŷ��B��;��ȃ�ޘ�idۃ��'ſu�A���q�tx�C���?2i�-��u,��0�,2a����;�Ǯ�X�F&�pV�î����k1�
�'8��x���c�,�)D�:�'��6� M -�h����˱td�ibFe=ڶ��.T��1���ۓ)��y	}tu�����~�����64m?�+]���$�3lz�����hl��P�Us��ф�����tQ�3$8	�n�@Ɨ�~]쥷:�$��[��Up0�~?H�y�������i��Zi��m.`��-�:�!izIj%"B~�/���6e�2z�c�1m;��5�I�������̉���2��W�Q��86A,�=l*@�i SLX1X%83�T�֜�ˇS.	|8�B\;�݋�T "����JإH�B�mF�"���O�1�@�7�_���@��x��@O��lw�]b�z#����2��2K��J�/���4_�|mj�</��>9�C�w��V�jr,Wu<�TT��x38!�L${�ٵCO҉�I�[���	!JE5\�H��q�	F����O�W�^&k�:��-T����1�\Eq�D��H�P��v�!=�y�N��~ ΩL�8�-۶��ϓn:�� 2,��n�,�O�O>��2��c��&NG6�-�P��9�Lp(�� �*}f��CMc��2��y���N-ВM����֑I,�d?b�����Q��޵�:�������"5��`�P�t��T���I.SR۱�87��y��rb'q�<n��I�X �h	����쐘[�fB��`�;`>Ǐ8����-�9��u�}����������"��w/	y�(J~I���b���\��oO����t������?�������	�>�|�#�Ñ�G�?x��[G?�X���k�bB�?�,L��!Y�0)�#TD�3�4�S(�x8F�[1�TȨ�ٖ�1BY��D3�(�����9���O�$������?���/�=��q��0�X�w��?����B�ꁿ~?���wl��^���9@��}��>D�&��{��a��"?������p1��
 -�\�X�M7s�h�|lh�XJ!�^�dX���tλ�^._(�t�Ytr[x��B|誆����]��Uŵfd#��X'�)�;#�$Ll�]҄Ыυ^�z�z����g����%��hu��*�PL�ϙc�^���آ9кB�n&h�.ř�h!�)��� ;nٙP�	f8��5��<3���U�l&��:3��i&;0�p�l�^"wg��A5�/8Ug�h������ș�.�Au�A�x^����v�2;�tM1�D.]�S��&�]&�Y	?7gJ�X���dWʶ�f���E,OR(C[k�I:
cik~��D���6Yf��e�г%=���B��;�NR2���uR��ME�\: �4ivGajV�k�E�>췻���&F�-ZUi�_Lz�V�L]�:���cQ�\��259��q]n���ifډ�ɚ�*��4���F�N��lܤ����ON��"rH�-D+z	]��o���?���D�
�DD�
�DD�
�DD�
�DD�
�DDv./a�]��R�&o��$���+���s�nV�b��-q*�m`Z1>\l��^�Ί�BUNΗ�=wQ=x(��V=�=�S=Q3e5� ���X3u;������m/��t����44g��qφ5Ҩ��Vo���(VM}�):!�Ҵz�`j���nMM��k��͑�&���q��M�O�1���q:�$$V河e-G�Z8������[���P�pn^�~2tj��pd�%b���d�4s:Sf�İ^���2�Q���y����3V˦���%s��*7ʹI+��X����v;>�E�w	�y�P��׷�p�z���Q�-��7�^{�6���X^lu���%�{c�+���y/n߂��M��9̏4��|x��k�#��>@�|��uj����_��Y}y3�F�5������Q�{����#W�'�x�C�|�����?��C�=x��W����e�������D]e�Lu��"�%�[[:__��O�t���qb��[f�,,g����Bnc5��t%r��/�[tL��.�ؔ�5�)�8���BA��Ri��e�3+�!0�	𘅐j�Rf�'R�)����8�$z$F���٩��� ��Ա:����ۢ������q�4�0�G��em�HwT~�����D:gK�(��P-KuW"i�r�L�΁�i����F��0M�B҂�v
*g�&���vT��N�+Ǒ�!%G��/�z�4�Vi��_ҧȚ��dS4�p�J�5e��גM\��
��J-��r����&Z����B,#�#4s��lG��P�5�1f�|/F[����ɂ�t�����J��C��ʅz��� L3.���i���������û�?�i '�t�5��A���G��*&\cE.$��E��-�l��F�3�~�z��J�˸�ܖ�]vG��ߣ�N�,�/�oV�i!y=�����thٓ]�&�Ƭ#i�L��'uq��4��pXR���_U�R]&�la��h��A#�[������Q5�룍,M���٬��;T�B�iʜm(��6Omf�1�ɏ�Nu0�Q���Dj>�h��q��=?��tB��L���t�ɴ���KV��ߥizڪE�J�QQҩj_,�c.]���j��@:o\j^,��tX1M���~<��\�n����J�.�Oc8F��9����g7����J�Ȋ@�,V�D����F�c2rW
	[V��d��HFf�v�<�ڏr�#!iBe����U&���T�H�v�U&E`λ
��y�V(��0T(WZ���Ni�<���S�:�b.���\\��U":kJ|������4:V�gQ�12x����Q��i��t�"�ew4�m
�j�
%R�����1S8.MI����,t�34U �{
1o��/����!y=��݌Z�2x'�&��'�J�n�t����� 	k��ұ��d�2*1fi^ǦҠi
57
K���lX[��F�+�X-�]�L�]Z٥���e>�٥���n^!³�_&�2��]ȳ�	y�آEE7&��U,p�f|���ς�\e�Ouq1Vo!o�#m�ey��#�nI]*��o!�?���y���-��G�%����A�<;|�|��0*��ʶ��x���7�+�Rx��1� %� d-�uFVE�0�Gdz�|��<+�S�?qN'p���J_����gqhY�(���2����>�?�C�^�E�eV������.��� �Ș_����0*���!�����^�h��^p�����Q�'AVm��wr��z��!���_v���;��Hw�a2�J҃ci"���q�!�w �i��=.gD�	����sdl����~�����������FU�kr~t�z� ��OW�=�[�g��"�[����E�U��Ui����8�Ѯ���j�����zz���,�.ِ���~x4.���6��Bz��GKZ�q���6b`�`m�OX�eq@�L btE�.T�e���4��@hgXＱIàe1�:�uA���\:	y#�wGSMKg�A`�S�
�_���՜���/��Wh5��Y-L|H8�4�?����w�п Μ����Egz�c�����[[�>�@P�*�2������Y����j�Y �@�X+�E�OZQ=�zUX��UX���ŶB�dG�KF���X[�Y��2����ڥ!t��|E���D���!ˀ��6`��e2.<���In%�m���Ö:���`qd�(p��բv�Wr9�|��B���?V6g}a{��u]�a�a�;��k�#���U �v]l*t�뒟% �<��	^ ��t�z�X��c�z:t�%> ����B�4XZ�z�.�dp��!��}�S,��̡̍��l�	�l�P8�@R��/O�pq��eW׀��5�^D����l����eu�.6����'JZ�J�D� �uep�mc[J� �T��(��Ap�`�8�$��Tro_@�����I�f_ưJ�@���\�1��>�K��d�N�&�@�mo˽�'��6�nw�)F�9ư�+ �
�1�)� �A{䢶�
��MP��?9	�z�� �Y0����X]��`m�3 	�^U�X�(�<(�e��ف4W����j��d`�g}���M�;�� d��ݴ�yj�v�,�0�I���}��n��G�����@ 땉*iְ�UW{�qNV�NñhP`���C�\l����{�����ǖ�7n�Kq�b�m�W�վ�"D�[�j1����Jֺm[͇7�Մ�8<uf��ɉ�ef2��`uXSuH�0O�i��5��cVǕ��(�������~82�m��1����s�b�JR�/�9������hwH[h�Ά�P�NPp����:����C�0G��#7�-�.7ԀO��GH>Źu��!?޵#|Y���5|_�?7>��qseW��'#�f�O2���H`�!C|B|� �Ԗm�숹a�JL���@f߆gu�:A3E>~��@d�g�b�Н�94��`�+V�"�-K[U��,��e��ǳ��F�]�z�O��٧c劆N���ڑB��!�j��$#1B�Ȑ"��n��6.Gڸ$͐�����f;FI�pT�J:��� j�w��1��b�Y�ϜX>�U�>i?��m��XO���!�Ŏ�&̮��,nV%��)5�M,�"�$�naRL�$�
ǔ��JHj� ���f2S��(I�&&��i��9�?�f���	���e��t=Eo�wnI��uG�,���̾'�������;���x��1x!��,W��:�e�"�9����e��Jsڹ8_�,ͲE�Tz�A�
�07��ėNL��g�������=�����%�������g�㱫r�HW[]�c�����*���vdg28�AGc����OZhG5��&����ZgZ�A�F[F{߸��m��&Sw�ֲ������C0ۭnΐ������~�a��$���Bz�� �$�M��9��A��}<E��x�]�y��rr=kE8�l>�g�gӡ:?AQܳFg��L��m�T��',	?�(���#^��.�Mx���76?���r%1��&��Y����`���Fg�K�덮��} ���zjמ���6π{̲Z�MZeK"-r�O�i�.q�� �)�\�?�+�S,���˝ 7b*��_(�z~[<=
�<qfޙ|֖4]�����E��`б���#��u��;�_C���Yt7�����u�e�Џ�n�_��ee�e�l�ap�Q���!	 �\�ح��|���]!yw�8���G,sV.f�&6�B�@GEg��7�:��������M��⿄I,r����t�����m�x�C��N�酯��������~X�}�W��7�o�������^>��ޒn6����������T� ���^�O�ئ�'#���Gڗ��?/�$p���M����|�����@����%<�<�<мP4���7J���G��u�����e�)rL�v�m�b�HT�-��1���-E�Z�Ho)T��C�	5#���dR�LY���N���?D����!��^�����y��f���u8���4u�W��9��w�i.���J~^�q��SI�zN��\SD�\�>#��Bd��d���i5ZV{x�-q#$-��V?~:)��I�R�t�T��bʬ&��xw�j�ű?�i痟^�8�����忍��q�����?N����^�O`;��C����/�6���O����/�����H� ����Y���}O�W:��A�߻��#��?�/����*. N����� ��]��Զ����Ւ�Џ�g���Ҿ��e��0Am�"t����t���]Yw�h׽�W����2�Z����7�bqEE���&��;ڝT�t�쫔�JJ��>���8����W�p�j����0�Q
j��|��� �������n���$Ԉ�a?�ԡ�����O�K�[��q������O����,k7��.�	�la����gQ����	�m�Ӻ�~"?��y}�:ڇw?�����v?��|2��ȧ��}��>���c�T���2k(��=렷�7{�Lv�}nm�i�b�^�+����U��[��1vK���~4�m~�C��|#5w�����}"?���v��-��Q���ߺ�5�t�|����P&ɹ7�,g�tK��ާx�-�+{���i{�ı+�h�=��5��������;D�Ҟ�|����ش�C��a�c��V��_�T%-1f;����f�B�A��2�@�=-��P����������P/�����Q���A������'����j����Wj���8���� ����������_���/�������'��?��W�7���K��}���n�鞟Ѹ��x@ۉ���[ٯ��?��/e}�GgM���y��?t�i�S?)�*φ�J�����׊��.�b-�Gti�I�|ͨ���)��Xp��v���O�������i]��쩬G�Zׇ���Ou��� j<���%�B�\I����[��m|����2�U2�;���Z�EwI�PJ��t�Ԧ�N�	Ao����|���A�3�$a�^���p���#�,P8��P\2�Fk}j���������?�_���[��l��B(�+ ��_[�Ձ��W�/����:�0�0ƟQX�4P,�,�R�hHz���>��M�4��磄O���pF�����(���r�+����程S,$�f���H�d�qWp�t�s�w-m�������o�l`n��p~���aD9���g1=`b�F��[NN��o��zC�^�c�(��X��� ��$��fDE��a3<)nЁ�����������+��V�:����������5�����ǥ�������C�W~e�w��:�r�GLd"g8�����eo'����,|���p���A���1����r��m�Dќ#�܌}Q<9$���a��1���8�r�3;4,s���<�cC�Q�lZ�CA��^������[jp���?������P��/������_���_�������Xj���N�8�2��s����������ܷE��	�;I�˧�]���$����[�k3̐�ښ�� �Ӄ?q �g=����T�ۣ���*U�z��g ��q��C[囍�>!�"��Kt��fȠ�j
j7Wz���4�a[,|���Q�Q'�4Jﺞ�O9�\ԛ�[p�~�^D��#�c<�w���)\s����x=��[B�	�z`'DrK��O�_����>��fB�}	��b�~��b�D
��>a�3���L��ØkBClm��3Q�Ǘa���'��&�"�TT��V���ө��x:���I��v;"�l����fh&}�,4�گ�C��[m���Iб������v��{Ѡ�#�?�_�����G}Q�������P�e�����?��_
J����-�������������������_m������q�GS��y(ɢL��>�r���4Ʌ��lH�^p=�%p<`��dB̥�;?u�������)�r���{�e��65]�G���G#^<IzN���,h]#�
_�͡�M�H�M� Z�Q�z�v�c#"�5!��x��&}��F=>�h��ɕ��3zx�h��s��N�H�e��(�n���{Q��?F>8���R����x��Y�e\���4���_j������%��w�u�u�?������WJ�����A;�&(��4�����+o�_����}�[?�7#�q�B��L�8��+�n��/*���x�6�-�������c���~_[��?�~������w�ys��}`Փ``��ɴ�Q�;2�$������92Z]���-�#f5�gSW�Ֆ�qLi��8i.���(���C��v���zO��k/Wz�z�^�N$�c�[X�����!�ao���m�6C_q��*�h-ƻT�t���Tv�k�-*�Hf�A#�m=k��[pԘk�7N��*47c;qG1hFJdR*����9HZ�����ks0��H�\4>�$����.u����V�r���^W@����_������?��u�����������o����o�����<��_e`�P�m�W���u(�����.�E�� �� ��/�����������������������V�<�Q���H�OB�_
���8�����(�����m�j ��W��p�wU���!�b ��W��؃����������r�������^��e�,�����J�?@��?��G8~
��؝��%��6C*��_[�Ղ�������P#����
P���Q�	�� � �� �����*�Q!����������P/��p��Q���A�	�� � �� ����������RP�����W�������?�7���p�{)�����C������a�����%�O��{��0�e��o��}���� P�m�W�'^�����P'�ǰ��А���3,��3�g>�>G�Dx!	�\�'H�w1�q9c\�sI�b��}�;��E���1��+���P]*�����V��;�����
Th��{�#BQ%��5��\��h���#��&���V�UK
�b��0�����Q�[���,Z��4��WI�#�-��1��TkR�����H��7v��>��7%�p�Iס��M�^��=��_��������+��V�:����������5�����ǥ�������C�W~e�7�	�:5�}+o56j���Y(v���/���N�3���������<�+�h�����vs%�WɘM�(�RW��vj)ۦ==�n�.����淃�&��6�%T� m7��\�t��ދz������$���������7��_��U`���`������W���
�B�]>�������_�)���M�	�dD�cqGỏ�-���o��Zٯ����*�$��6�z��:yO�����2��fC:.�-M��i�Eh#�@��X�d�?4�#��Ecf�X�����|Q���t��":%rط\=��I��k�q��J_3��.�x��7얐k�彰"�%\�w��א7����w�Q4��q$H��]7�u��,�O����t�V��e��dCT:�ɳ�����8�M&���w���>�N��<�F��tT>��$ ��s��j�8O��3��aK,��MJ1[㿿��O�����[������_����[
>���>��ǯ?q�#\�2P��#���w)����S��x�e\�����2P��Q��K���r��9�2=ꇲ���?������e�-�O�D����?4��6��$f�	�`��].��_��ђx��!⯛�I�~vܤˏ��JW�G�������|�܏��|���\�^z����u�jBt�.�W���\^SK�?ǖ�-�"��iU�ﮫ&�u���n����62zedd@���Z�vr]����1��T"\.V��+�3�z��=L�W����mbU��c���|�`l>���s��}���7wzk�.�5��|�������C��ٺ<dt������ȈQ`������n���a�ɍ�{lv���/퐥Kj���^d>�y/6Y��.ex�F�1�X�d�q��+�
��lDJ$�v�r�4E���5�>�u�D�Ζ��c��K�����~7�B�Qw���-	��?ƣP���cf,F�.7#|̽<L�>7CI����gH�����>壡�an��X �ݟ�:���������W��Kt4�;���bo塈����l��!�<z@)� �;B�2�/W��V��ȕ�Z�����?�W���
#��+u�C��?��JA	�p�j�2����}?�G��+o��������?e��Va|�ef8������V�����^��z����1�o�m����j�!���&�`߼������~��|?���f�
��a�HwR:[��9>�����U�i��с�s��ŵ�Y���'��3v6.&�V7���;��~�G}���<��\O.ֱ�7���g�8j0��m'[^�Ngi�2���W�˂W�ǾO��r0i{�5����Z�!����D�P�k�zi�>�^~���W)��k΅M8'Wa�9nzce�%�������0������P��?�����RP���ri��C�e1���8~�����+�	Ù�Q.�.�^�ƿ肀�(��1���r���2�����������W���N�X��(�sXȉ���Jm��a�C���˼q�E���/[����l������5���C�����:迋ڻ�(�2P��߽���	���?����_աd����vPmP��c������R�V�G��?x��4�ݦ��kC;�z2��g�a>��Hy���	�-������V��n�>Jk}~Q@�5�r"Y2�Iӳ��Ϻ�<���������|��{�����խs�<]��/�=���;�'5�m���_��I�:�<�<䡧Nn�"ؾ�޺��@@Q����v'��L:3i6ק*i�A�-|�Z{��vuX[����+�������I-���(tƵN���u�CO�p�k�f������QX����7ǧڪ�`b���fqo3+S,�m�JGpK��\������V�Y���2����������7��>KQ�Ɗ'��͡�zv��(v�~��kkW�ǋmÖ��ac�8�*#[���E��~r�^WYMm�0&��)�F�Z�ù_U��^�Ģ��m;kV�^o 8�]0%�.[+��(U^��G�~yA�T�"��e��z���7�i�`�Q������LȢ�74p��
���m��A�a�'td���?r��_��E�������O����O�������p�%��߶�����td��P.g��������?��g���oP��A�w��ޢ�?����*��"�������?r���E�w������E�?�9����_�����L@��� �k@�A���?M]���O�R��.z@�A���?se�
�?r��PY����`H���P��?@���%�ye��?2��I!������\����dD�2BБ����C��P�!�����P����������������\�?��##'�u!�����C��0��	P��?@����v��J������_������o��˅�3W�?@�W&�C�!����!���������#9��AJ�oe��Lp����m�y��"u������78��LR/�sV3��ss�*�&cX��*�X��K&e0�aYzYK���I�I�ȑ�1|�[��'�_�.���φ�����oT����\����x���&SN~�%��u\��2k��@�ks�icr�n���ǁ4łZ��ضߠ��V����hO��Ң'��Ճ�k�[4}T��]��RH�l��f��
kI�\e�=��4U�Y�9�v�Z5�(W�gnq��[_�K�uT�AyEV|����]\��y����':P���f}�@���Б���t�����'n �V�]������G��f7iyW�u�11I,���l��8n��zږ�]T[��i���kTG�����6�x=r[�l��`�R�K�#���Rm���z� �k8W5��.����o������Jl�A
�S�'���Z���a�(�C�7���Q�B�"���_���_���?`�!�!���X���K~���߬��h��?��5?�=�gF�\���������>�bE��3������(ξl�^��	�"�M�7�$ɶ���[���X�G��N
|I���Ċǅ-��;<���d^u��4H�Go�km��������!���R��ۦ����s��U�0�"�m���z���@��5�kT��(v���{������D�ĉ�`�77�jEp�W�|/M>�ͧ$6_Mp�%�N-g�Օ�Zso�i�m���y�l*S!~8��ôU%L����0�!�.�����!C�G�.�������&�Z?����<���P������S����5�G^�� ������J������Ӌ�5��O@�?�?j������Y��,@��i��q@�A���?u%��2���Xu[�"���������񿙐'��*�ٓ��o���������?B�G��x�����������	��?X)��߶������������������ �#���qJ�?���JTڷ�#v��U�{nn�� ��#�u��?b�1�#M���X���1�#�0���~���+r'Mq����~��}��^���-:Q��OT���8�S�c֖]��u��1/o�V{C*��^p6dg�4'H�4B_��Ì5>M65�v_�i����}N�Ů��jz��qD��ah�iT��H����؇ceZ�{���LW'��]����y\u&�N��fD�s�3�I[��6��D7ܬ���5��6���'�nŢ���fmf{�a�,U�0��OG�_�ng� ���#���bp�mq�����_.�����'�|	� ����J�/
��3�A�/��������� ���yp�Mq�����_.��%A��#��� �5���!����+�4��E�Gu;��E$W.�Ԗ=hN�?�������q,������魍������{9 ��/�r J�p[+��q�h���f����ME����R�}3$0%�{%�rԧao�,�m��"��R�X��a��v �&�� ,M���^,�=A�ǍuaQ��B�R�}%Z��̹*6��.,jay��dY�J�Ȇ�MK��zdR+�5��4�EҦ�qݚP�V�/ܟލ�����������2���ip�-q�����_��H]��X�ς��?SfxC+��i�V.i�H�Œ:��K[4M��&K��e����Y.����>�ou����A����	����#���3��0nI��|���d�4�Z����d�k�֪fN�r�y��c��Mh����h� �[��v�j������.jZk���ܩ�Ѕ�i�Q#� WO�q��œ�e�8����FX��������@����@�n�'�?��ȅ�C�2����"����)n�<�?������?ޭǋeM�ȪH�I�B�m�[n���ZtwJ�b�D�������#�������s�5!��Cc�b~t�WG�,�x�N����vŇ�Wͨ-���T�謽�?n�uhM.C���Z���_��<� �� FH.� ����_���_0�����ѐ��e�`�!�[��8��l����0|n��;A��8nI�"��/o�=� �H��� `���(��p���\�մnArx��Zq���;M7V��9*���|*c+�h,g%>:r\�b[-��։���z�*�
�m[\/%qu����R;OԄ��}����kU�T�ú�c��,t�51nJ_�`�LJ���'�a�/�d7�j��H:q ۖW����"�1������,<e��4��D]��!=Uꟶ-?ۋ�W�E��D��Ҽ�Z7[�lH�H>�wɩ�P8��ٱe,/V����c$��B�=,�=5�W#Z]����·S�G�e�/g0~��/�8������G�������I�/��f��A�3�ܝۦ�'��@�L��s�p�eg�6��|/�� ��T�?v�A���θ�������������KOwN�l*��ǄN��y���E��3V������>o����Di����~>����?�qpxyP����ş_+�y��_����1�}�ӧ$�=n���ߘ��8������x�ߞ���;.�k����WN�{.n9A�fx�?q?p������h�<��B3���}��F�9y����.01�'�?�g�j�DN6�I�,��G7vA`&Ǜ;A���������?pc��?��o|��Q��?��ÞT�_��~}���;����x��J��=��� �����c�����I���.�'�����Y'o��p�����ӫ���]-/��G����6��8ᑇ?>]�n�kh��=���!/�v��6�N�-���w�pg�_
r �J��>�{��'���n��������rm�_�pm��onM��,��/�I2�ל��i�i���K'��������w~e<�_<ɒ�@-�isfd�ύG<��D>=Y�s��:���_\��Wq��xR�W�ةV{����n�����8�4�a��y^���OJwx���Y��{�}�O�`z�����7�G                           ��?��� � 