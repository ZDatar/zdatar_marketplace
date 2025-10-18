import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_constants.dart';

class FileUploadSection extends StatelessWidget {
  final PlatformFile? selectedFile;
  final Function(PlatformFile?) onFileSelected;

  const FileUploadSection({
    super.key,
    required this.selectedFile,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Upload Area
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedFile != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedFile != null
                  ? theme.colorScheme.primary.withOpacity(0.05)
                  : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            child: InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(12),
              child: selectedFile != null
                  ? _buildSelectedFileView(theme)
                  : _buildUploadPrompt(theme),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // File Requirements
        _buildFileRequirements(theme),

        const SizedBox(height: 16),

        // Action Buttons
        if (selectedFile != null) _buildActionButtons(theme),
      ],
    );
  }

  Widget _buildUploadPrompt(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 64,
          color: theme.colorScheme.primary.withOpacity(0.7),
        ),
        const SizedBox(height: 16),
        Text(
          'Upload Your Dataset',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Click to browse and select your data file',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.folder_open),
          label: const Text('Browse Files'),
        ),
      ],
    );
  }

  Widget _buildSelectedFileView(ThemeData theme) {
    final fileSizeInMB =
        (selectedFile!.size / (1024 * 1024)).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getFileIcon(selectedFile!.extension),
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedFile!.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.storage,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '${fileSizeInMB}MB',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.description,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                selectedFile!.extension?.toUpperCase() ?? 'Unknown',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'File Selected',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileRequirements(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'File Requirements',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRequirementItem(
              theme,
              'Supported formats: ${AppConstants.supportedFileTypes.join(', ').toUpperCase()}',
              Icons.description,
            ),
            _buildRequirementItem(
              theme,
              'Maximum file size: ${AppConstants.maxFileSize ~/ (1024 * 1024)}MB',
              Icons.storage,
            ),
            _buildRequirementItem(
              theme,
              'No personal identifiable information (PII)',
              Icons.security,
            ),
            _buildRequirementItem(
              theme,
              'Data should be properly structured and clean',
              Icons.data_object,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(ThemeData theme, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.refresh),
            label: const Text('Change File'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onFileSelected(null),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remove'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedFileTypes,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size
        if (file.size > AppConstants.maxFileSize) {
          // Show error - file too large
          return;
        }

        onFileSelected(file);
      }
    } catch (e) {
      // Handle error
      print('Error picking file: $e');
    }
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'json':
        return Icons.data_object;
      case 'csv':
        return Icons.table_chart;
      case 'parquet':
        return Icons.storage;
      case 'zip':
        return Icons.archive;
      default:
        return Icons.description;
    }
  }
}
