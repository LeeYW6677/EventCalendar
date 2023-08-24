using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;

namespace EventCalendar
{
    [Serializable]
    public class Event
    {
        public int EventId { get; set; }
        private static int nextEventId = 0;
        public string EventName { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public string Description { get; set; }
        public string Color { get; set; }
        public Event()
        {
            this.EventId = nextEventId++;
        }
    
    }
}