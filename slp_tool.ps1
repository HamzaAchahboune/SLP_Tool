function pixel(){
    Write-Host ""
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                     ████████ ██     ██████   ████████   █████     █████   ██     " -ForegroundColor white
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                     ██       ██     ██  ██      ██    ██     ██ ██     ██ ██     " -ForegroundColor white
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                     ████████ ██     ██████      ██    ██     ██ ██     ██ ██     " -ForegroundColor white
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                           ██ ██     ██          ██    ██     ██ ██     ██ ██     " -ForegroundColor white
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                     ████████ ██████ ██     ██   ██      █████     █████   ██████ " -ForegroundColor white
    Start-Sleep -Milliseconds 50
    Write-Host ""
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                      SLP tool, simple manager of SLP protocol in a ESXi server "
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                         0 : Return the Menu "
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                         X : Exit The Script"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                     ============================================================="
    Start-Sleep -Milliseconds 50
    Write-Host ""
}
          
function Help(){
    Write-Host "                                                                      SLP : service location protocol"
    Write-Host "                                                                      ==============================="
    Write-Host "Alternative method :"
    Write-Host "================== "
    Write-Host "Clients can still access services using alternative methods for example :"
    Write-Host "    • Using DNS to locate IP of servers who offer services"
    Write-Host "    • Using configuration files to locate services"
    Write-Host "This method is more complex and less efficient So the SLP can offer the solution for service discovery"
    Write-Host ""
    Write-Host "SLP Method :"
    Write-Host "========== "

    Write-Host "• SLP is a protocol used for the discovery of services on network"
    Write-Host "• SLP allow client to search services in network using some request diffused by the provider of service"
    Write-Host "THow SLP protocol work : "
    Write-Host ""
    Write-Host "    1. Service agents  : Devices on the network that provide services (e.g. printers, file servers) register their services with an SLP Directory Agent. The service agent                         includes information about the service, such as its type, address, and port number"
    Write-Host "    2. Directory agents: Devices on the network that act as directory agents maintain a list of registered services and respond to queries from clients. Directory agents                          are responsible for forwarding queries to service agents and returning the results to clients."
    Write-Host "    3. Service requests: Clients that need to locate a service send a query to the SLP directory agent. The query includes the type of service being requested and any                             additional criteria (e.g. location)."
    Write-Host "    4. Service response: The directory agent responds to the client with a list of available services that match the requested criteria"
    Write-Host ""
    Write-Host "    5. Service usage   : Once the client has received the list of available services, it can use the service by contacting the service agent directly using the                                    information provided in the response"

    Write-Host "CVE-2021-21974 :" 
    Write-Host "============== " 
    Write-Host "  • Tracked as CVE-2021-21974, the security flaw is caused by a heap overflow issue in the OpenSLP service that can be exploited by unauthenticated threat actors in               low-complexity attacks."
    Write-Host "  • As current investigations, these attack campaigns appear to be exploiting the vulnerability CVE-2021-21974, for which a patch has been available since 23 Feb 2021,       CERT-FR said.
      • The systems currently targeted would be ESXi hypervisors in version 6.x and prior to 6.7
      • To block incoming attacks, admins have to disable the vulnerable Service Location Protocol (SLP) service on ESXi hypervisors that haven't yet been updated."

    Write-Host " SLP.TOOL :"
    Write-Host " ========" 
    Write-Host "    To use the SLP.TOOL in powershell version you should follow This steps :"
    Write-Host "         1. install VMware.PowerCLI  "
    Write-Host "         2. Then u should connect to the ESXI server " 
    Write-Host "         3. Check the state of slp protocol if slp up or down in esxi server " 
    Write-Host "         4. To start the slp protocol " 
    Write-Host "         5. To Stop the slp protocol  " 
    Write-Host "         7. For mor information about tool and slp protocol in general " 
    Write-Host " " 
    Write-Host " "
    Write-Host " "
    Write-Host "                                                                                                                                     @Hamza_Achahboune"

   
}

function IS_SLP_Enable() {
    pixel
    $EsxiAddress = Read-Host "Enter IP address of ESXi server"

    # Check if the IP address is valid
    if (-not ([System.Net.IPAddress]::TryParse($EsxiAddress, [ref][System.Net.IPAddress]::Null))) {
        Write-Host "Invalid IP address"
        return
    }

    # Send a ping request to the ESXi server
    $Ping = New-Object System.Net.NetworkInformation.Ping
    $PingReply = $Ping.Send($EsxiAddress)

    if ($PingReply.Status -eq "Success") {
        $slpPort = 427
        $Client = New-Object System.Net.Sockets.TcpClient

        try {
                # Try to connect to SLP port
            $Client.Connect($EsxiAddress, $slpPort)
            Write-Host "SLP is active on $EsxiAddress"
        } catch {
            Write-Host "SLP is not active on $EsxiAddress"
        } finally {
            $Client.Close()
        }
    } else {
        Write-Host "Address not reachable"
    }
      
 }

function Disable_SLP() {
    pixel
    $EsxiAddress = Read-Host "Enter IP address of ESXi server (or 0 to return to the menu)"
    if ($EsxiAddress -eq "0") {
        return
    }

    try {
        #Connect to esxi server 
        Connect-VIServer -Server $EsxiAddress -ErrorAction Stop
        $Slp_Conf = Get-VMHostService -VMHost $EsxiAddress | Where-Object {$_.Key -eq "slpd"}

        if ($Slp_Conf.Running){
            Get-VMHostService | Where-Object {$_.Key -eq "slpd"} | Stop-VMHostService -Confirm:$false
            Write-Host "SLP is disabled successfully."
        }elseif(!$Slp_Conf.Running){
            Write-Host "SLP is already disabled."
        }
    } catch {
        Write-Host "Error: $($_.Exception.Message)"
    }


}

function Activate(){
    pixel
    $EsxiAddress = Read-Host "Enter IP address of ESXi server (or 0 to return to the menu)"
    if ($EsxiAddress -eq "0") {
        return
    }
     try {
        Connect-VIServer -Server $EsxiAddress -ErrorAction Stop
        $Slp_Conf = Get-VMHostService -VMHost $EsxiAddress | Where-Object {$_.Key -eq "slpd"}


        if ($Slp_Conf.Running){
            Write-Host "SLP is already enabled."
        }elseif(!$Slp_Conf.Running){
            Get-VMHost $EsxiAddress | Get-VMHostService | Where-Object {$_.Key -eq "slpd"} | Start-VMHostService -Confirm:$false  
            Write-Host "SLP has been enabled."
        }
    } catch {
        Write-Host "Error: $($_.Exception.Message)"
    }

}

function Connect(){
    pixel

    $Ip = Read-Host "Enter ESXi address"
    if ($Ip -eq "0") {
        return
    }
    
    $Con = Connect-VIServer -Server $Ip -ErrorAction SilentlyContinue
        
     if ($Con -ne $null) {
           Write-Host "Successfully connected to ESXi server."
     } else {
           Write-Host "Error connecting to ESXi server." 
      }

}

function Install(){
    pixel
    if (!(Get-Module -Name VMware.PowerCLI -ListAvailable)) {
         Write-Host "Installing VMware.PowerCLI module..."
         Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force
         Write-Host "VMware.PowerCLI module installed."
      } else {
         Write-Host "VMware.PowerCLI module is already installed."
      }

 }

function Show-Menu {
    Clear-Host
    pixel
    Write-Host "                                                                                   ==============================="
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                              MENU OPTIONS"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                   ==============================="
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      1. Install VMware Module"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      2. Connect to Esxi server"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      3. Check The SLP state"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      4. Start The SLP Protocol"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      5. Stop The SLP Protocol "
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      6. Disconnect and exit"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                      7. Help"
    Start-Sleep -Milliseconds 50
    Write-Host "                                                                                   ==============================="
    Start-Sleep -Milliseconds 50
}


do {
    Show-Menu
    $input = Read-Host "                                                                                         Enter your choice"
    switch ($input) {
        '1' {
            # Install Modeule
            Clear-Host
            Install
            Pause
        }
        '2' {
            # Connect to esxi
            Clear-Host
            Connect
            Pause
        }
        '3' {
            # Check SLP state
            Clear-Host
            IS_SLP_Enable
            Pause
        }
        '4' {
            Clear-Host
            Activate
            Pause
        }
        '5' {
            Clear-Host
            Disable_SLP
            pause
        }
        '6' {
            # Exit the menu
            break
        }
        '7' {
            Clear-Host
            Help
            Pause
            
        }

    }
} Until($input -eq 'X')






