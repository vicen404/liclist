#!/bin/sh

[ ! $1 ] && echo "Uso: listado_licencias.sh <fichero.xml>" && exit 1

echo "Licencias que aparecen en el fichero $1"
echo -e "\nFormato de salida\n--------------------------------------"
echo "#Cantidad - Descripción de la licencia"
echo -e "\n\nOutput:"

echo "Licencias incluidas"

> license_name.tmp
> license_quantity.tmp

cat $1|grep " LicenseName="|egrep -v "Quantity=\"0\""|sed "s/<//g"|sed "s/\/>//g"|while read linea;do
	tipo="LicenseName="
	echo $linea|awk -F "\" " -v var=$tipo '{for (i=1; i<=NF; ++i) if ( match($i,var) ) {print $i}}' >> license_name.tmp
	tipo="Quantity="
	echo $linea|awk -F "\" " -v var=$tipo '{for (i=1; i<=NF; ++i) if ( match($i,var) ) {print $i}}' >> license_quantity.tmp
done
paste license_name.tmp license_quantity.tmp|awk -F"\"" '{print $3" - "$2}'|sed "s/Quantity=//g"|sed "s/-1/Ilimitadas/g"
rm license_name.tmp license_quantity.tmp

> license_name.tmp
> license_quantity.tmp

echo -e "\n\nLicencias NO incluidas:"

cat $1|grep " LicenseName="|egrep "Quantity=\"0\""|sed "s/<//g"|sed "s/\/>//g"|while read linea;do
	tipo="LicenseName="
	echo $linea|awk -F "\" " -v var=$tipo '{for (i=1; i<=NF; ++i) if ( match($i,var) ) {print $i}}' >> license_name.tmp
	tipo="Quantity="
	echo $linea|awk -F "\" " -v var=$tipo '{for (i=1; i<=NF; ++i) if ( match($i,var) ) {print $i}}' >> license_quantity.tmp
done
paste license_name.tmp license_quantity.tmp|awk -F"\"" '{print "0 - "$2}'|sed "s/Quantity=//g"
rm license_name.tmp license_quantity.tmp
