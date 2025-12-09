import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tools_app/features/guides/data/repositories/guides_repository.dart';
import 'package:smart_tools_app/features/guides/domain/entities/guide_entity.dart';
import 'package:smart_tools_app/features/guides/presentation/cubit/guides_cubit.dart';
import 'package:smart_tools_app/features/guides/presentation/cubit/guides_state.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuidesCubit(GuidesRepository())..loadGuides(),
      child: const _GuidesView(),
    );
  }
}

class _GuidesView extends StatelessWidget {
  const _GuidesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panduan & Literasi')),
      body: BlocBuilder<GuidesCubit, GuidesState>(
        builder: (context, state) {
          if (state is GuidesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GuidesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is GuidesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.guides.length,
              itemBuilder: (context, index) {
                final guide = state.guides[index];
                return _buildGuideCard(context, guide);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, Guide guide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.push('/guides/detail', extra: guide);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                guide.thumbnailUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.category.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guide.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guide.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
