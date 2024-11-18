import streamlit as st
import mysql.connector

# Connect to MySQL database
def get_db_connection():
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Veeresh@123',  # Replace with your MySQL password
        database='AirlineReservationManagement'
    )
    return conn

# Function to make a booking
def make_booking(passenger_id, flight_id, seat_number, class_type, booking_status):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Insert booking into Booking table
        query = """
            INSERT INTO Booking (passenger_id, flight_id, seat_number, booking_status, class)
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (passenger_id, flight_id, seat_number, booking_status, class_type))
        conn.commit()

        # Fetch the updated loyalty points for the passenger
        cursor.execute("SELECT points_available FROM LoyaltyProgram WHERE passenger_id = %s", (passenger_id,))
        loyalty_points = cursor.fetchone()

        if loyalty_points:
            points = loyalty_points[0]
        else:
            points = 0  # Default if no loyalty program entry exists

        conn.close()
        return True, points
    except mysql.connector.Error as e:
        return False, str(e)

# Streamlit UI
st.title('SkyHigh Airlines Booking System')

# Form for booking
with st.form("booking_form"):
    passenger_id = st.number_input("Enter Passenger ID", min_value=1, step=1)
    flight_id = st.number_input("Enter Flight ID", min_value=1, step=1)
    seat_number = st.text_input("Enter Seat Number")
    class_type = st.selectbox("Select Class", ['Economy', 'Business', 'First'])
    booking_status = st.selectbox("Select Booking Status", ['Confirmed', 'Canceled'])

    submitted = st.form_submit_button("Make Booking")

    if submitted:
        if passenger_id and flight_id and seat_number and class_type and booking_status:
            success, result = make_booking(passenger_id, flight_id, seat_number, class_type, booking_status)
            if success:
                st.success(f"Booking successful! Updated loyalty points: {result}")
            else:
                st.error(f"Booking failed: {result}")
        else:
            st.error("Please fill all the fields.")

# Show all bookings
if st.checkbox("Show All Bookings"):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Booking")
    bookings = cursor.fetchall()
    conn.close()

    if bookings:
        st.write("### All Bookings")
        st.table(bookings)
    else:
        st.info("No bookings found.")
