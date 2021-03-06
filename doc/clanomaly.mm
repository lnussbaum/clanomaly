<map version="0.9.0">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1338361446167" ID="ID_1225162175" MODIFIED="1346107267242" TEXT="Clanomaly - outliers detection">
<node CREATED="1338529108427" ID="ID_1421664951" MODIFIED="1338529131292" POSITION="right" TEXT="goals">
<node CREATED="1338529133639" ID="ID_743826413" MODIFIED="1338529140926" TEXT="detect nodes that are unsuitable for an experiment"/>
<node CREATED="1338529147169" ID="ID_303297126" MODIFIED="1338529160858" TEXT="store state of nodes to later understand performance results"/>
</node>
<node CREATED="1338361468077" ID="ID_1542016235" MODIFIED="1346107270854" POSITION="right" TEXT="list hardware, filter output to find clusters of identical nodes">
<node CREATED="1338362030892" ID="ID_1607566941" MODIFIED="1345489752966" TEXT="lspci">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361491049" ID="ID_43864641" MODIFIED="1345489757000" TEXT="lshw">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361495978" ID="ID_1047861720" MODIFIED="1338361498762" TEXT="dmidecode"/>
<node CREATED="1338361500914" ID="ID_1417045316" MODIFIED="1345489762740" TEXT="hwloc">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361571774" ID="ID_1401651077" MODIFIED="1338361572911" TEXT="discover"/>
<node CREATED="1338361574487" ID="ID_1638185916" MODIFIED="1345492573426" TEXT="hwinfo">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361585647" ID="ID_29210075" MODIFIED="1338361638420" TEXT="ohai"/>
<node CREATED="1338362191109" ID="ID_281757924" MODIFIED="1338362196803" TEXT="optionally compare with G5K API"/>
<node CREATED="1346107277269" ID="ID_1445135056" MODIFIED="1346107518626" TEXT="first hardware dumper with lshw, hwloc, /proc/cpuinfo, lspci">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1346110412748" ID="ID_170678951" MODIFIED="1346110427211" TEXT="introduce notion of comparable check, and enable output of groups"/>
</node>
<node CREATED="1346107297455" ID="ID_1416622218" MODIFIED="1346107522276" TEXT="second hardware dumper with hwinfo">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1338361733008" ID="ID_1245785273" MODIFIED="1342300243686" POSITION="right" TEXT="analyse system configuration">
<node CREATED="1338361737400" ID="ID_1543880505" MODIFIED="1345494909513" TEXT="partitions, filesystems, filesystems options">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361742847" ID="ID_1459792741" MODIFIED="1338361751510" TEXT="installed packages + versions"/>
<node CREATED="1338361755679" ID="ID_1408303409" MODIFIED="1346111060433" TEXT="running kernel, loaded modules">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338361770151" ID="ID_1022611043" MODIFIED="1338361771620" TEXT="dmesg output"/>
<node CREATED="1338362347477" ID="ID_1417905872" MODIFIED="1346111078915" TEXT="some options in /proc / sysctl">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1338362354654" ID="ID_1289774623" MODIFIED="1346111078914" TEXT="IO scheduler">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338362578652" ID="ID_1038032598" MODIFIED="1346111078913" TEXT="cpufreq scheduler">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338362590434" ID="ID_1088727944" MODIFIED="1346111078912" TEXT="TCP tunings">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1338364143004" ID="ID_1010560512" MODIFIED="1346111078911" TEXT="all sysctls??">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1346111269155" ID="ID_157783451" MODIFIED="1346111276108" TEXT="some relevant stuff in /sys"/>
<node CREATED="1342300263891" ID="ID_1895564182" MODIFIED="1342300267564" TEXT="check connectivity">
<node CREATED="1342300270340" ID="ID_1071550273" MODIFIED="1342300272629" TEXT="ethtool"/>
<node CREATED="1342300274471" ID="ID_1769861325" MODIFIED="1342300289239" TEXT="ibv_devinfo"/>
</node>
<node CREATED="1346111316744" ID="ID_33381616" MODIFIED="1346111326900" TEXT="debian packages, config files, etc."/>
</node>
<node CREATED="1338361669699" ID="ID_585985261" MODIFIED="1338361971833" POSITION="right" TEXT="test performance">
<node CREATED="1338361684394" ID="ID_746891879" MODIFIED="1338361687610" TEXT="CPU"/>
<node CREATED="1338361972598" ID="ID_1671189631" MODIFIED="1338361982796" TEXT="detect cache size and performance (can we trust Cloud envs ?)"/>
<node CREATED="1338361689570" ID="ID_1198166250" MODIFIED="1338361932942" TEXT="memory">
<node CREATED="1338361935328" ID="ID_177796429" MODIFIED="1338361939198" TEXT="stream ?"/>
</node>
<node CREATED="1338361692554" ID="ID_2620533" MODIFIED="1338361702337" TEXT="disk(s)">
<node CREATED="1338361951263" ID="ID_1667622804" MODIFIED="1338361953389" TEXT="fio ?"/>
</node>
<node CREATED="1338361719569" ID="ID_184892008" MODIFIED="1338362041114" TEXT="network(s)">
<node CREATED="1338362006765" ID="ID_4433965" MODIFIED="1338362066204" TEXT="between pairs of nodes to check latency and bandwidth">
<node CREATED="1338362052011" ID="ID_1702562914" MODIFIED="1338362063901" TEXT="ib_*"/>
<node CREATED="1338362066204" ID="ID_1666214117" MODIFIED="1338362097559" TEXT="(e)ping"/>
<node CREATED="1338362071146" ID="ID_859278927" MODIFIED="1338362093840" TEXT="nuttcp?"/>
</node>
<node CREATED="1338362142103" ID="ID_1147420409" MODIFIED="1338362145686" TEXT="latency + bw matrix">
<node CREATED="1338362160790" ID="ID_980315213" MODIFIED="1338362164005" TEXT="Luc&apos;s tool ?"/>
<node CREATED="1338362167190" ID="ID_1654002030" MODIFIED="1338362171660" TEXT="MPIGraph ?"/>
<node CREATED="1338362256123" ID="ID_728091978" MODIFIED="1338362259921" TEXT="with clusters detection ?"/>
</node>
</node>
</node>
<node CREATED="1338363389623" ID="ID_696822627" MODIFIED="1338363398213" POSITION="right" TEXT="output report (wiki-like, html?)"/>
<node CREATED="1338362106376" ID="ID_582487240" MODIFIED="1338362115703" POSITION="right" TEXT="make sure no daemons are remaining after tests"/>
<node CREATED="1338529017569" ID="ID_776884842" MODIFIED="1338529021236" POSITION="right" TEXT="design">
<node CREATED="1338529026874" ID="ID_1949272479" MODIFIED="1338529038017" TEXT="run from a central node which connects to all other nodes"/>
<node CREATED="1338529041518" ID="ID_880203416" MODIFIED="1338529054369" TEXT="store results on the central node (easier to archive)"/>
<node CREATED="1338529055594" ID="ID_720999176" MODIFIED="1338529089825" TEXT="reports full results and anomalies"/>
</node>
</node>
</map>
