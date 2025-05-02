#!/bin/bash

# * Bloc Smith is created by Siva Sankar
# Updated on: 02/05/2025
# Purpose: Enforces best practices for Flutter projects using Modular Cubit/Bloc Architecture

# ! Usage Rules
# 1 - This script is open source; you may share and distribute it under the MIT License.

# ! How to Use
# 01 - Clone or download the "blocsmith.sh" script from the GitHub repository:
#      Repo: https://github.com/siva-sankar-dev/flutter-automation.git
# 02 - Move the script to the root directory of your Flutter project.
# 03 - Grant execution permissions (only required once):
#      chmod +x blocsmith.sh
# 04 - Execute the script to generate the necessary module structure:
#      ./blocsmith.sh

# Fetch the developer's name from Git config
developer_name=$(git config --get user.name)
# Get today's date
today_date=$(date +"%Y-%m-%d")

# Ask for the module name
read -p "Enter module name (snake_case): " module_name

# Ask for state management choice
echo "Choose state management approach:"
options=("cubit" "bloc")
select sm_choice in "${options[@]}"; do
  if [[ "$sm_choice" == "cubit" || "$sm_choice" == "bloc" ]]; then
    break
  else
    echo "Invalid choice. Try again."
  fi
done

# Ask for additional packages to install
read -p "Enter additional packages to install (space-separated, e.g. dio sizer): " extra_packages

# Prepare pub dependencies
# always include bloc, flutter_bloc, equatable
deps=("bloc" "flutter_bloc" "equatable")
# add extras if provided
if [[ -n "$extra_packages" ]]; then
  deps+=( $extra_packages )
fi

echo "Installing packages: ${deps[*]}"
flutter pub add "${deps[@]}"

# Convert snake_case to PascalCase
to_pascal() {
  echo "$1" | awk -F'_' '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1)) substr($i,2)}'
}
class_name=$(to_pascal "$module_name")

# Paths
module_root="lib/modules/$module_name"
services_dir="$module_root/services"
logic_dir="$module_root/$sm_choice"
view_dir="$module_root/view"

# Create directories
echo "Creating module folders..."
mkdir -p "$services_dir" "$logic_dir" "$view_dir"

# 1) Service
cat <<EOF > "$services_dir/${module_name}_service.dart"
/// Service for $class_name module
/// Created by: $developer_name on $today_date
class ${class_name}Service {
  // TODO: implement service methods
}
EOF

# 2) Logic (Cubit/Bloc)
echo "Generating $sm_choice files..."
if [[ "$sm_choice" == "cubit" ]]; then
  # Cubit & State
  cat <<EOF > "$logic_dir/${module_name}_cubit.dart"
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../services/${module_name}_service.dart';
part '${module_name}_state.dart';

/// Cubit for $class_name
class ${class_name}Cubit extends Cubit<${class_name}State> {
  final ${class_name}Service _service = ${class_name}Service();
  ${class_name}Cubit() : super(${class_name}Initial());
  // TODO: add cubit methods
}
EOF
  cat <<EOF > "$logic_dir/${module_name}_state.dart"
part of '${module_name}_cubit.dart';

/// States for ${class_name}Cubit
@immutable
abstract class ${class_name}State {}
class ${class_name}Initial extends ${class_name}State {}
EOF
else
  # Bloc, Event, State
  cat <<EOF > "$logic_dir/${module_name}_event.dart"
import 'package:equatable/equatable.dart';
/// Events for $class_name
abstract class ${class_name}Event extends Equatable {
  const ${class_name}Event();
  @override List<Object?> get props => [];
}
EOF
  cat <<EOF > "$logic_dir/${module_name}_state.dart"
import 'package:equatable/equatable.dart';
/// States for $class_name
abstract class ${class_name}State extends Equatable {
  const ${class_name}State();
  @override List<Object?> get props => [];
}
class ${class_name}Initial extends ${class_name}State {}
EOF
  cat <<EOF > "$logic_dir/${module_name}_bloc.dart"
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../services/${module_name}_service.dart';
import '${module_name}_event.dart';
import '${module_name}_state.dart';
/// Bloc for $class_name
class ${class_name}Bloc extends Bloc<${class_name}Event, ${class_name}State> {
  final ${class_name}Service _service = ${class_name}Service();
  ${class_name}Bloc() : super(${class_name}Initial()) {
    // TODO: handle events
  }
}
EOF
fi

# 3) View
echo "Generating view file..."
cat <<EOF > "$view_dir/${module_name}_view.dart"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
EOF
# import logic
if [[ "$sm_choice" == "cubit" ]]; then
  echo "import '../cubit/${module_name}_cubit.dart';" >> "$view_dir/${module_name}_view.dart"
else
  echo "import '../bloc/${module_name}_bloc.dart';" >> "$view_dir/${module_name}_view.dart"
fi
# append view class
echo "
/// View for $class_name module
class ${class_name}View extends StatelessWidget {
  const ${class_name}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ${class_name}$( [[ "$sm_choice" == "cubit" ]] && echo "Cubit()" || echo "Bloc()" ),
      child: Scaffold(
        appBar: AppBar(title: const Text('$class_name View')),
        body: const Center(child: Text('Welcome to $class_name Module')),
      ),
    );
  }
}" >> "$view_dir/${module_name}_view.dart"

echo "Module '$module_name' created with services, $sm_choice, and view."
