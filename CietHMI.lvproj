<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="17008000">
	<Property Name="varPersistentID:{1EDD56FB-1BE7-4F0A-A33F-CF1EADED9AD8}" Type="Ref">/My Computer/HMILibrary.lvlib/T_n</Property>
	<Property Name="varPersistentID:{53FD2597-3EE5-4D67-9394-D57E2559B7C3}" Type="Ref">/My Computer/HMILibrary.lvlib/Outputs</Property>
	<Property Name="varPersistentID:{C6B9D2E2-2A5B-46B4-AD3F-23664DADEFA8}" Type="Ref">/My Computer/HMILibrary.lvlib/NonTInputs</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="HMILibrary.lvlib" Type="Library" URL="../HMILibrary.lvlib"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="matscript.dll" Type="Document"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
