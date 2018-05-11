<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="17008000">
	<Property Name="varPersistentID:{1EDD56FB-1BE7-4F0A-A33F-CF1EADED9AD8}" Type="Ref">/My Computer/HMILibrary.lvlib/T_n</Property>
	<Property Name="varPersistentID:{81A5F35B-682C-4978-86E7-F1F3D33AF891}" Type="Ref">/My Computer/HMILibrary.lvlib/CTAHfreq</Property>
	<Property Name="varPersistentID:{86951F4D-88C8-42D0-ACCC-23C6D80616C5}" Type="Ref">/My Computer/HMILibrary.lvlib/colors</Property>
	<Property Name="varPersistentID:{90613212-7871-4B2D-92A9-D65C3827BB70}" Type="Ref">/My Computer/HMILibrary.lvlib/PC_temps</Property>
	<Property Name="varPersistentID:{C6B9D2E2-2A5B-46B4-AD3F-23664DADEFA8}" Type="Ref">/My Computer/HMILibrary.lvlib/NonTInputs</Property>
	<Property Name="varPersistentID:{E3F09E8B-9FDD-425F-9FBD-611463CF8D8E}" Type="Ref">/My Computer/HMILibrary.lvlib/desiredPower</Property>
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
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Write Delimited Spreadsheet (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (DBL).vi"/>
				<Item Name="Write Delimited Spreadsheet (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (I64).vi"/>
				<Item Name="Write Delimited Spreadsheet (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet (string).vi"/>
				<Item Name="Write Delimited Spreadsheet.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Delimited Spreadsheet.vi"/>
				<Item Name="Write Spreadsheet String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Spreadsheet String.vi"/>
			</Item>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
