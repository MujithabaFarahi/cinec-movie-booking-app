import 'package:cinec_movies/Models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie/movie_bloc.dart';
import '../widgets/appbar.dart';
import '../widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieBloc>(context).add(GetAllBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Bookings'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state.isLoading) {
              return ListView.separated(
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = BookingModel(
                    id: 'id',
                    movieId: 'movieId',
                    userId: 'userId',
                    showTimeId: 'showTimeId',
                    movieTitle: 'movieTitle',
                    posterUrl: 'posterUrl',
                    showDateTime: DateTime.now(),
                    seats: ['A1', 'A2'],
                    bookedAt: DateTime.now(),
                  );
                  return BookingCard(booking: booking, isLoading: true);
                },
              );
            }

            if (state.bookings.isEmpty) {
              return const Center(
                child: Text(
                  'No bookings yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: state.bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return BookingCard(booking: booking);
              },
            );
          },
        ),
      ),
    );
  }
}
