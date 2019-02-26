using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Aula1BD
{
    public partial class MainForm : Form
    {
        #region Instance Fields
        private string DbServer { get; set; }
        private string DbName { get; set; }
        private string UserName { get; set; }
        private string UserPass { get; set; }

        private SqlConnection CN { get; set; }
        #endregion

        public MainForm()
        {
            InitializeComponent();
        }
        
        #region Button Events
        private void testDbConnection_Click(object sender, EventArgs e)
        {
            UpdateInfo();
            TestDBConnection(DbServer, DbName, UserName, UserPass);
        }

        private void seeTable_Click(object sender, EventArgs e)
        {
            UpdateInfo();

            string result = GetTableContent(CN);

            MessageBox.Show(result); 
        }
        #endregion

        #region Auxiliar Methods 
        private void UpdateInfo()
        {
            DbServer = textBoxServer.Text;
            DbName = textBoxUser.Text;
            UserName = textBoxUser.Text;
            UserPass = textBoxPassword.Text;
        }

        #endregion
        #region Auxiliar Methods (given)
        private void TestDBConnection(string dbServer, string dbName, string userName, string userPass)
        {
    

            CN = new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName +
                                                       "; uid = " + userName + ";" + "password = " + userPass);

            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    MessageBox.Show("Successful connection to database " + CN.Database + " on the " + CN.DataSource + " server", "Connection Test", MessageBoxButtons.OK);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("FAILED TO OPEN CONNECTION TO DATABASE DUE TO THE FOLLOWING ERROR \r\n" + ex.Message, "Connection Test", MessageBoxButtons.OK);
            }

            if (CN.State == ConnectionState.Open)
                CN.Close();
        }

        private string GetTableContent(SqlConnection CN)
        {
            string str = "";

            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    int cnt = 1;
                    SqlCommand sqlcmd = new SqlCommand("SELECT * FROM Hello", CN);
                    SqlDataReader reader;
                    reader = sqlcmd.ExecuteReader();

                    while (reader.Read())
                    {
                        str += cnt.ToString() + " - " + reader.GetInt32(reader.GetOrdinal("MsgID")) + ", ";
                        str += reader.GetString(reader.GetOrdinal("MsgSubject"));
                        str += "\n";
                        cnt += 1;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("FAILED TO OPEN CONNECTION TO DATABASE DUE TO THE FOLLOWING ERROR \r\n" + ex.Message, "Connection Error", MessageBoxButtons.OK);
            }

            if (CN.State == ConnectionState.Open)
                CN.Close();

            return str;
        }
    }
    #endregion

}

