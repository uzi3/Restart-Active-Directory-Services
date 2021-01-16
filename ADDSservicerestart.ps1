#Get the ADDS and its dependent services
$set1 = @((Get-Service -Name ntds).Name)
$set2 = Get-Service -Name ntds -dependent | foreach {$_.name}
$set3 = $set1 + $set2

#Restart the ADDS and its dependent services
$job = start-job -scriptblock {Restart-Service -name ntds -force}

#Give time to restart the services
start-sleep -Seconds 120

#Check status of service and if required restart the service
foreach ($i in $set3) 
    {$status=(get-service -name $i).status
        If ($status -eq "Stopping") 
            {$PI=Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$i'" | Select-Object -ExpandProperty ProcessId
            taskkill.exe /PID $PI /F
            Start-Sleep -Seconds 5
            }#endif
            Restart-Service -Name $i
     }#endforeach
