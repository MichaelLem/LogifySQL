using System;
using System.Configuration;
using Microsoft.Data.SqlClient;

public class DbConnectionTester
{
    public string TestConnection()
    {
        try
        {
            string message = string.Empty;
            var connectionString = ConfigurationManager.ConnectionStrings["LogifyDb"].ConnectionString;

            using var connection = new SqlConnection(connectionString);
            connection.Open();

            using var cmd = new SqlCommand("SELECT 1;", connection);
            var result = (int)cmd.ExecuteScalar();
            connection.Close();


            message = $"Connection OK. Test query returned: {result}";
            return message;
        }
        catch (Exception ex)
        {
            string error  = "Connection FAILED: " + ex.Message;
            return error;
        }
    }
}
