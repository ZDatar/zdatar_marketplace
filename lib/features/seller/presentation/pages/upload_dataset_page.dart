import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../models/dataset.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/upload_step_indicator.dart';
import '../widgets/file_upload_section.dart';
import '../widgets/metadata_form.dart';
import '../widgets/pricing_section.dart';
import '../widgets/preview_section.dart';

class UploadDatasetPage extends ConsumerStatefulWidget {
  const UploadDatasetPage({super.key});

  @override
  ConsumerState<UploadDatasetPage> createState() => _UploadDatasetPageState();
}

class _UploadDatasetPageState extends ConsumerState<UploadDatasetPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form data
  PlatformFile? _selectedFile;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DatasetCategory? _selectedCategory;
  List<String> _tags = [];
  final _priceController = TextEditingController();
  String _selectedCurrency = 'USDC';
  String? _selectedRegion;
  DateTime? _dataStartDate;
  DateTime? _dataEndDate;
  bool _hasSample = false;
  bool _isUploading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Dataset'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: UploadStepIndicator(
            currentStep: _currentStep,
            totalSteps: 4,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildFileUploadStep(),
          _buildMetadataStep(),
          _buildPricingStep(),
          _buildPreviewStep(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(theme),
    );
  }

  Widget _buildFileUploadStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Your Dataset',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the data file you want to sell on the marketplace.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FileUploadSection(
              selectedFile: _selectedFile,
              onFileSelected: (file) {
                setState(() {
                  _selectedFile = file;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dataset Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide details about your dataset to help buyers understand its value.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: MetadataForm(
              titleController: _titleController,
              descriptionController: _descriptionController,
              selectedCategory: _selectedCategory,
              tags: _tags,
              selectedRegion: _selectedRegion,
              dataStartDate: _dataStartDate,
              dataEndDate: _dataEndDate,
              hasSample: _hasSample,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              onTagsChanged: (tags) {
                setState(() {
                  _tags = tags;
                });
              },
              onRegionChanged: (region) {
                setState(() {
                  _selectedRegion = region;
                });
              },
              onStartDateChanged: (date) {
                setState(() {
                  _dataStartDate = date;
                });
              },
              onEndDateChanged: (date) {
                setState(() {
                  _dataEndDate = date;
                });
              },
              onHasSampleChanged: (hasSample) {
                setState(() {
                  _hasSample = hasSample;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Price',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Determine the price for your dataset. Consider the data quality, size, and market demand.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PricingSection(
              priceController: _priceController,
              selectedCurrency: _selectedCurrency,
              onCurrencyChanged: (currency) {
                setState(() {
                  _selectedCurrency = currency;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Publish',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your dataset details before publishing to the marketplace.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PreviewSection(
              file: _selectedFile,
              title: _titleController.text,
              description: _descriptionController.text,
              category: _selectedCategory,
              tags: _tags,
              price: double.tryParse(_priceController.text) ?? 0.0,
              currency: _selectedCurrency,
              region: _selectedRegion,
              dataStartDate: _dataStartDate,
              dataEndDate: _dataEndDate,
              hasSample: _hasSample,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _isUploading ? null : _previousStep,
                  child: const Text('Previous'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isUploading ? null : _nextStep,
                child: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_currentStep == 3 ? 'Publish Dataset' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _publishDataset();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_selectedFile == null) {
          _showError('Please select a file to upload');
          return false;
        }
        if (_selectedFile!.size > AppConstants.maxFileSize) {
          _showError('File size exceeds maximum limit of ${AppConstants.maxFileSize ~/ (1024 * 1024)}MB');
          return false;
        }
        return true;
      case 1:
        if (_titleController.text.trim().isEmpty) {
          _showError('Please enter a dataset title');
          return false;
        }
        if (_descriptionController.text.trim().isEmpty) {
          _showError('Please enter a dataset description');
          return false;
        }
        if (_selectedCategory == null) {
          _showError('Please select a category');
          return false;
        }
        if (_dataStartDate == null || _dataEndDate == null) {
          _showError('Please select data date range');
          return false;
        }
        return true;
      case 2:
        if (_priceController.text.trim().isEmpty) {
          _showError('Please enter a price');
          return false;
        }
        final price = double.tryParse(_priceController.text);
        if (price == null || price <= 0) {
          _showError('Please enter a valid price');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _publishDataset() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Simulate upload and encryption process
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        Navigator.of(context).pop();
        _showSuccess();
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to publish dataset: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 48,
        ),
        title: const Text('Dataset Published!'),
        content: const Text(
          'Your dataset has been successfully uploaded and published to the marketplace. It will be available for purchase once the blockchain transaction is confirmed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
