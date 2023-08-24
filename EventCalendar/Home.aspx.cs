using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Security.Policy;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace EventCalendar
{
    public partial class Home : System.Web.UI.Page
    {
        List<Event> events = new List<Event>();
        List<Event> eventList = new List<Event>();
        protected void Page_Load(object sender, EventArgs e)
        {
            //initialize
            if (!IsPostBack)
            {
                ViewState["CurrentYear"] = DateTime.Now.Year;
                ViewState["CurrentMonth"] = DateTime.Now.Month;
                ViewState["Days"] = DateTime.DaysInMonth((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"]);
                initializeEvent();
                setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
            }
            loadEvent();

        }

        //previous year
        protected void prevYear_Click(object sender, EventArgs e)
        {
            ViewState["CurrentYear"] = (int)ViewState["CurrentYear"] - 1;
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //next year
        protected void nextYear_Click(object sender, EventArgs e)
        {
            ViewState["CurrentYear"] = (int)ViewState["CurrentYear"] + 1;
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);

        }

        //previous month
        protected void prevMonth_Click(object sender, EventArgs e)
        {
            if ((int)ViewState["CurrentMonth"] != 1)
            {
                ViewState["CurrentMonth"] = (int)ViewState["CurrentMonth"] - 1;
            }
            else
            {
                //deduct year instead when month = Jan
                ViewState["CurrentYear"] = (int)ViewState["CurrentYear"] - 1;
                ViewState["CurrentMonth"] = 12;
            }
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //next month
        protected void nextMonth_Click(object sender, EventArgs e)
        {
            if ((int)ViewState["CurrentMonth"] != 12)
            {
                ViewState["CurrentMonth"] = (int)ViewState["CurrentMonth"] + 1;
            }
            else {
                //add year instead when month = Dec
                ViewState["CurrentYear"] = (int)ViewState["CurrentYear"] + 1;
                ViewState["CurrentMonth"] = 1;
            }
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //createCalendarDate
        protected void setDate(int year, int month, int day)
        {
            //get all events
            events = (List<Event>)ViewState["Event"];

            //set calendar year and month
            txtYear.Text = year.ToString();
            txtMonth.Text = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month);
            selectedDate.InnerText = txtMonth.Text + " " + txtYear.Text;

            //get first day for current month
            int firstDay = (int)(new DateTime(year, month, 1).DayOfWeek);

            //for table row setting
            int count = 0;
            TableRow row = new TableRow();
            TableCell cell = new TableCell();

            //get total day in current month
            int daysInMonth = DateTime.DaysInMonth(year, month);

            for (int i = 0; i < daysInMonth + firstDay; i++)
            {
                cell = new TableCell();

                if (i < firstDay)
                {                    
                    //create empty cell
                    cell.Text = "";
                }
                else
                {
                    //create date cell
                    cell.Text = (i - firstDay + 1).ToString() + "<br/>";

                    //get date of current cell
                    DateTime date = new DateTime((int)ViewState["CurrentYear"],(int)ViewState["CurrentMonth"], (i - firstDay + 1));

                    //add marker if there is event
                    foreach (Event eventItem in events) {
                        if (date >= eventItem.StartDateTime.Date && date <= eventItem.EndDateTime.Date) {
                            cell.Text += "<label style=\"color:" + eventItem.Color + "\">&bull;</label>";
                        }
                    }

                    //highlight if the date is today
                    if (i == DateTime.Now.Day + 1 && month == DateTime.Now.Month && year == DateTime.Now.Year)
                    {
                        cell.CssClass = "highlight";
                    }
                }
                row.Cells.Add(cell);
                count++;

                //if 7 days added or last day of the month
                if (count == 7 || i == daysInMonth + firstDay - 1)
                {
                    //add row and reset
                    dateTable.Rows.Add(row);
                    row = new TableRow();
                    count = 0;
                }

            }
        }

        private void Btn_Click(object sender, EventArgs e)
        {
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //add predefined event
        protected void initializeEvent()
        {
            Event event1 = new Event
            {
                EventName = "Team Meeting",
                StartDateTime = DateTime.Parse("2023-08-10 14:00:00"),
                EndDateTime = DateTime.Parse("2023-08-10 15:00:00"),
                Description = "Team meeting to discuss project updates.",
                Color = "#FF0000"
            };
            events.Add(event1);

            Event event2 = new Event
            {
                EventName = "Client Presentation",
                StartDateTime = DateTime.Parse("2023-08-10 10:00:00"),
                EndDateTime = DateTime.Parse("2023-08-10 11:00:00"),
                Description = "Client meeting for project presentation.",
                Color = "#345322"
            };
            events.Add(event2);

            Event event3 = new Event
            {
                EventName = "Product Launch",
                StartDateTime = DateTime.Parse("2023-10-20 15:30:00"),
                EndDateTime = DateTime.Parse("2023-10-20 18:00:00"),
                Description = "Launch event for the new product line.",
                Color = "#FF0000"
            };
            events.Add(event3);

            Event event4 = new Event
            {
                EventName = "Training Workshop",
                StartDateTime = DateTime.Parse("2023-07-25 09:00:00"),
                EndDateTime = DateTime.Parse("2023-07-25 16:00:00"),
                Description = "Full-day training workshop for employees.",
                Color = "#AE1230"
            };
            events.Add(event4);

            Event event5 = new Event
            {
                EventName = "Conference",
                StartDateTime = DateTime.Parse("2023-08-30 08:30:00"),
                EndDateTime = DateTime.Parse("2023-09-02 17:00:00"),
                Description = "Annual industry conference with guest speakers.",
                Color = "#9433FA"
            };
            events.Add(event5);
            ViewState["Event"] = events;
        }

        //display event for current month
        protected void loadEvent()
        {
            //get event for current month
            events = ((List<Event>)ViewState["Event"]);
            List<Event> eventList = ((List<Event>)ViewState["Event"])
                .Where(ev =>
                    (ev.StartDateTime.Month == (int)ViewState["CurrentMonth"] &&
                    ev.StartDateTime.Year == (int)ViewState["CurrentYear"]) ||
                    (ev.EndDateTime.Month == (int)ViewState["CurrentMonth"] &&
                    ev.EndDateTime.Year == (int)ViewState["CurrentYear"]))
                .ToList();
            eventList = eventList.OrderBy(ev => ev.StartDateTime).ToList();
            if (eventList.Count == 0)
            {
                //if no event
                empty.Visible = true;
            }
            else
            {
                empty.Visible = false;
            }
            eventRepeater.DataSource = eventList;
            eventRepeater.DataBind();
        }

        //display add Modal
        protected void addEventButton_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showAddModal", "var addModal = new bootstrap.Modal(document.getElementById('addModal')); addModal.show();", true);
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //add Event to list
        protected void btnSaveEvent_Click(object sender, EventArgs e)
        {
            Event newEvent = new Event
            {
                EventName = txtEventName.Text,
                StartDateTime = DateTime.Parse(txtStartDate.Text),
                EndDateTime = DateTime.Parse(txtEndDate.Text),
                Description = txtEventDescription.Text,
                Color = txtColor.Text
            };
            events.Add(newEvent);
            ViewState["Event"] = events;
            loadEvent();
  
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //display edit modal
        protected void btnEdit_Command(object sender, CommandEventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showEditModal", "var editModal = new bootstrap.Modal(document.getElementById('editModal')); editModal.show();", true);

            //get selected event
            int eventId = Convert.ToInt32(e.CommandArgument);
            Event eventToEdit = events.FirstOrDefault(ev => ev.EventId == eventId);

            txtEventID.Text = eventId.ToString();
            txtEventName1.Text = eventToEdit.EventName;
            txtStartDate1.Text = eventToEdit.StartDateTime.ToString("yyyy-MM-ddTHH:mm");
            txtEndDate1.Text = eventToEdit.EndDateTime.ToString("yyyy-MM-ddTHH:mm");
            txtEventDescription1.Text = eventToEdit.Description;
            txtColor1.Text = eventToEdit.Color;

            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //edit selected event
        protected void btnEditEvent_Click(object sender, EventArgs e)
        {
            //get selected event
            int eventId = Convert.ToInt32(txtEventID.Text);
            int index = events.FindIndex(ev => ev.EventId == eventId);

            events[index].EventName = txtEventName1.Text;
            events[index].StartDateTime = DateTime.Parse(txtStartDate1.Text);
            events[index].EndDateTime = DateTime.Parse(txtEndDate1.Text);
            events[index].Description = txtEventDescription1.Text;
            events[index].Color = txtColor1.Text;

            ViewState["Event"] = events;
            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }
        
        //display delete modal
        protected void btnDelete_Command(object sender, CommandEventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showDeleteModal", "var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal')); deleteModal.show();", true);

            //get selected event
            int eventId = Convert.ToInt32(e.CommandArgument);
            txtEventID1.Text = eventId.ToString();

            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        //delete event from list
        protected void btnDeleteEvent_Click(object sender, EventArgs e)
        {
            //get selected event
            int eventId = Convert.ToInt32(txtEventID1.Text);
            int index = events.FindIndex(ev => ev.EventId == eventId);

            events.RemoveAt(index);

            loadEvent();
            setDate((int)ViewState["CurrentYear"], (int)ViewState["CurrentMonth"], (int)ViewState["Days"]);
        }

        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (DateTime.Parse(txtStartDate.Text) < DateTime.Parse(txtEndDate.Text))
            {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }              
        }
    }
}