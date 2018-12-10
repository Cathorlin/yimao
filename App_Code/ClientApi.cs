using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Diagnostics;

public static class CustomerMAC
{
    /// <summary>
    /// 根据IP获取客户端网卡的MAC
    /// </summary>
    /// <param name="IP">客户端IP</param>
    /// <returns>网卡MAC</returns>
    public static string GetCustomerMAC(string IP)
    {
        string dirResults = "";
        ProcessStartInfo psi = new ProcessStartInfo();
        Process proc = new Process();
        psi.FileName = "nbtstat";
        psi.RedirectStandardInput = false;
        psi.RedirectStandardOutput = true;
        psi.Arguments = "-A " + IP;
        psi.UseShellExecute = false;
        proc = Process.Start(psi);
        dirResults = proc.StandardOutput.ReadToEnd();
        proc.WaitForExit();
        dirResults = dirResults.Replace(" ", "").Replace(" ", "").Replace(" ", "");

        Regex reg = new Regex("MAC[ ]{0,}Address[ ]{0,}=[ ]{0,}(?<key>((.)*?))MAC", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        Match mc = reg.Match(dirResults + "MAC");

        if (mc.Success)
        {
            return mc.Groups["key"].Value;
        }
        else
        {
            reg = new Regex("Host not found", RegexOptions.IgnoreCase | RegexOptions.Compiled);
            mc = reg.Match(dirResults);
            if (mc.Success)
            {
                return "Host not found!";
            }
            else
            {
                return "";
            }
        }
    }
}