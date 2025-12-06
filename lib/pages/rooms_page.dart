// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/providers/user_provider.dart';
import 'package:study_planner/services/firebase_data_service.dart';
import 'package:study_planner/theme/app_theme.dart';
import 'package:study_planner/utils/file_reader.dart';

class RoomsPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> subjects;
  final VoidCallback onRefresh;
  final bool isLoading;

  const RoomsPage({
    super.key,
    required this.subjects,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  ConsumerState<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends ConsumerState<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: widget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 64, color: cs.secondaryText),
                  const SizedBox(height: 12),
                  Text(
                    loc.roomsEmptyTitle,
                    style: GoogleFonts.poppins(
                      color: cs.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: widget.onRefresh,
                    icon: Icon(Icons.refresh, color: cs.onSurface),
                    label: Text(
                      loc.commonReload,
                      style: TextStyle(color: cs.onSurface),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: widget.subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final s = widget.subjects[idx];
                final rawTitle =
                    s['nome']?.toString() ?? s['atividade']?.toString() ?? '';
                final title = rawTitle.isNotEmpty ? rawTitle : loc.roomsNoName;
                final group = s['turma']?.toString() ?? '-';
                final year = s['ano']?.toString() ?? '-';
                final term = s['periodo']?.toString() ?? '-';
                final subtitle = loc.roomsSubtitle(group, year, term);
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RoomDetailPage(subject: s),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? cs.secondaryBackground
                          : cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              title.isNotEmpty ? title[0].toUpperCase() : '?',
                              style: GoogleFonts.poppins(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: cs.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class RoomDetailPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> subject;
  const RoomDetailPage({super.key, required this.subject});

  @override
  ConsumerState<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends ConsumerState<RoomDetailPage> {
  List<Map<String, dynamic>> _posts = [];
  bool _loading = true;

  AppLocalizations get loc => AppLocalizations.of(context)!;

  String _getRoomId() {
    final nome = widget.subject['nome']?.toString() ?? '';
    final turma = widget.subject['turma']?.toString() ?? '';
    final ano = widget.subject['ano']?.toString() ?? '';
    final periodo = widget.subject['periodo']?.toString() ?? '';

    final nomeNormalizado = nome.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    return '${nomeNormalizado}_${turma}_${ano}_$periodo';
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _loading = true);
    final roomId = _getRoomId();
    if (roomId.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final posts = await FirebaseDataService.fetchRoomPosts(roomId);
    setState(() {
      _posts = posts;
      _loading = false;
    });
  }

  Future<void> _showNewPostDialog() async {
    final user = ref.read(userProvider);
    final email = user?.email ?? '';
    final displayName = user?.displayName ?? '';

    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    PlatformFile? pickedFile;
    String? pickedName;
    Uint8List? pickedData;
    String? pickedPath;
    bool uploading = false;
    double uploadProgress = 0.0;
    const int maxFileBytes = 10 * 1024 * 1024; // 10 MB

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setState2) {
            final loc = AppLocalizations.of(ctx2)!;

            void showUploadError(String message) {
              ScaffoldMessenger.of(
                ctx2,
              ).showSnackBar(SnackBar(content: Text(message)));
            }

            Future<void> pickFile() async {
              try {
                final res = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [
                    'pdf',
                    'jpg',
                    'jpeg',
                    'png',
                    'gif',
                    'webp',
                  ],
                  withData: true,
                  withReadStream: true,
                );
                if (res == null || res.files.isEmpty) return;

                final file = res.files.first;
                final path = kIsWeb ? null : file.path;

                // Try to get bytes immediately if available
                Uint8List? data = file.bytes;

                // If bytes are not available and we have a path (mobile/desktop), try reading
                if (data == null && path != null) {
                  try {
                    data = await readFileBytes(path);
                  } catch (_) {
                    // Ignore error here, will try again in resolvePickedBytes
                  }
                }

                setState2(() {
                  pickedFile = file;
                  pickedName = file.name;
                  pickedPath = path;
                  pickedData = data;
                });
              } catch (e) {
                debugPrint('Error picking file: $e');
                showUploadError(loc.somethingWrong);
              }
            }

            Future<Uint8List?> resolvePickedBytes() async {
              // 1. Return if already available
              if (pickedData != null) return pickedData;

              try {
                // 2. Try getting bytes directly from file object
                if (pickedFile?.bytes != null) {
                  pickedData = pickedFile!.bytes;
                  return pickedData;
                }

                // 3. Try reading from stream (Web support)
                if (pickedFile?.readStream != null) {
                  final stream = pickedFile!.readStream!;
                  final builder = BytesBuilder();

                  // Wrap stream reading in a future to allow timeout if needed externally
                  // or just rely on the stream completing.
                  await for (final chunk in stream) {
                    builder.add(chunk);
                  }

                  pickedData = builder.takeBytes();
                  return pickedData;
                }

                // 4. Try reading from path (Mobile/Desktop support)
                if (pickedPath != null) {
                  final bytes = await readFileBytes(pickedPath!);
                  if (bytes != null) {
                    pickedData = bytes;
                    return bytes;
                  }
                }
              } catch (e) {
                debugPrint('Error resolving file bytes: $e');
              }

              return null;
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx2).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.roomsNewPostTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(ctx2).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        hintText: loc.roomsPostTitleHint,
                        filled: true,
                        fillColor: Theme.of(ctx2).brightness == Brightness.dark
                            ? Theme.of(ctx2).cardColor
                            : Theme.of(ctx2).colorScheme.primaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bodyCtrl,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: loc.roomsPostBodyHint,
                        filled: true,
                        fillColor: Theme.of(ctx2).brightness == Brightness.dark
                            ? Theme.of(ctx2).cardColor
                            : Theme.of(ctx2).colorScheme.primaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: pickFile,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Anexar arquivo'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pickedName ?? loc.roomsNoAttachment,
                            style: GoogleFonts.poppins(
                              color: Theme.of(ctx2).colorScheme.secondaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: uploading
                                ? null
                                : () async {
                                    final title = titleCtrl.text.trim();
                                    final body = bodyCtrl.text.trim();
                                    final hasAttachment =
                                        pickedData != null ||
                                        pickedFile != null;
                                    if (title.isEmpty &&
                                        body.isEmpty &&
                                        !hasAttachment) {
                                      return;
                                    }

                                    setState2(() {
                                      uploading = true;
                                      uploadProgress = 0;
                                    });

                                    bool success = false;
                                    try {
                                      if (kDebugMode) {
                                        debugPrint(
                                          '🚀 Iniciando envio de post...',
                                        );
                                      }

                                      final roomId = _getRoomId();
                                      if (roomId.isEmpty) {
                                        if (kDebugMode) {
                                          debugPrint('❌ Room ID vazio');
                                        }
                                        showUploadError(loc.somethingWrong);
                                        return;
                                      }

                                      String? attachmentUrl;
                                      String? attachmentName;

                                      if (pickedFile != null ||
                                          pickedData != null) {
                                        if (kDebugMode) {
                                          debugPrint('📎 Processando anexo...');
                                        }

                                        final estimatedSize =
                                            pickedFile?.size ??
                                            pickedData?.lengthInBytes;
                                        if (estimatedSize != null &&
                                            estimatedSize > maxFileBytes) {
                                          if (kDebugMode) {
                                            debugPrint(
                                              '❌ Arquivo muito grande: $estimatedSize bytes',
                                            );
                                          }
                                          showUploadError(
                                            loc.roomsAttachmentTooLarge(10),
                                          );
                                          return;
                                        }

                                        if (kDebugMode) {
                                          debugPrint(
                                            '📖 Lendo bytes do arquivo...',
                                          );
                                        }
                                        final data = await resolvePickedBytes()
                                            .timeout(
                                              const Duration(seconds: 30),
                                              onTimeout: () {
                                                if (kDebugMode) {
                                                  debugPrint(
                                                    '⏱️ Timeout ao ler arquivo',
                                                  );
                                                }
                                                return null;
                                              },
                                            );

                                        if (data == null) {
                                          if (kDebugMode) {
                                            debugPrint(
                                              '❌ Falha ao ler bytes do arquivo',
                                            );
                                          }
                                          showUploadError(
                                            loc.roomsAttachmentReadError,
                                          );
                                          return;
                                        }

                                        if (kDebugMode) {
                                          debugPrint(
                                            '✅ Arquivo lido: ${data.lengthInBytes} bytes',
                                          );
                                        }

                                        if (data.lengthInBytes > maxFileBytes) {
                                          if (kDebugMode) {
                                            debugPrint(
                                              '❌ Arquivo muito grande após leitura',
                                            );
                                          }
                                          showUploadError(
                                            loc.roomsAttachmentTooLarge(10),
                                          );
                                          return;
                                        }

                                        if (kDebugMode) {
                                          debugPrint(
                                            '📤 Enviando arquivo para Firebase...',
                                          );
                                        }
                                        final url =
                                            await FirebaseDataService.uploadRoomAttachment(
                                              subjectId: roomId,
                                              filename:
                                                  pickedName ??
                                                  loc.roomsAttachmentDefaultName,
                                              data: data,
                                              onProgress: (p) {
                                                if (!ctx2.mounted) return;
                                                if (kDebugMode) {
                                                  debugPrint(
                                                    '📊 Progresso UI: ${(p * 100).toStringAsFixed(1)}%',
                                                  );
                                                }
                                                setState2(() {
                                                  uploadProgress = p;
                                                });
                                              },
                                            ).timeout(
                                              const Duration(minutes: 2),
                                              onTimeout: () {
                                                if (kDebugMode) {
                                                  debugPrint(
                                                    '⏱️ Timeout no upload do Firebase',
                                                  );
                                                }
                                                return null;
                                              },
                                            );
                                        if (url == null) {
                                          if (kDebugMode) {
                                            debugPrint(
                                              '❌ Upload retornou URL nula',
                                            );
                                          }
                                          showUploadError(loc.somethingWrong);
                                          return;
                                        }

                                        if (kDebugMode) {
                                          debugPrint(
                                            '✅ Upload concluído: $url',
                                          );
                                        }
                                        attachmentUrl = url;
                                        attachmentName =
                                            pickedName ??
                                            loc.roomsAttachmentDefaultName;
                                      }

                                      if (kDebugMode) {
                                        debugPrint(
                                          '💾 Salvando post no banco de dados...',
                                        );
                                      }

                                      final post = {
                                        'title': title,
                                        'body': body,
                                        'authorEmail': email,
                                        'authorName': displayName,
                                        'createdAt': DateTime.now()
                                            .toIso8601String(),
                                      };
                                      if (attachmentUrl != null) {
                                        post['attachmentUrl'] = attachmentUrl;
                                        post['attachmentName'] =
                                            attachmentName ??
                                            loc.roomsAttachmentDefaultName;
                                      }
                                      final saved =
                                          await FirebaseDataService.saveRoomPost(
                                            subjectId: roomId,
                                            post: post,
                                          );
                                      if (!saved) {
                                        if (kDebugMode) {
                                          debugPrint('❌ Falha ao salvar post');
                                        }
                                        showUploadError(loc.somethingWrong);
                                        return;
                                      }

                                      if (kDebugMode) {
                                        debugPrint('✅ Post salvo com sucesso!');
                                      }
                                      success = true;

                                      if (ctx2.mounted) {
                                        Navigator.of(ctx2).pop(true);
                                      }
                                    } catch (e, stack) {
                                      if (kDebugMode) {
                                        debugPrint(
                                          '❌ Erro geral no upload: $e',
                                        );
                                        debugPrint('Stack: $stack');
                                      }
                                      showUploadError(loc.somethingWrong);
                                    } finally {
                                      if (kDebugMode) {
                                        debugPrint(
                                          '🏁 Finalizando (success=$success)...',
                                        );
                                      }
                                      if (ctx2.mounted && !success) {
                                        setState2(() {
                                          uploading = false;
                                          uploadProgress = 0;
                                        });
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                ctx2,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                ctx2,
                              ).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: uploading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: uploadProgress > 0
                                              ? uploadProgress
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        uploadProgress > 0
                                            ? '${(uploadProgress * 100).toStringAsFixed(0)}%'
                                            : loc.roomsUploading,
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  )
                                : Text(loc.roomsPublishButton),
                          ),
                        ),
                      ],
                    ),
                    if (uploading && uploadProgress > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(value: uploadProgress),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (ok == true) await _loadPosts();
  }

  Future<void> _deletePost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        final loc = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: Theme.of(ctx).brightness == Brightness.dark
              ? Theme.of(ctx).cardColor
              : cs.surface,
          title: Text(
            loc.roomsDeletePostTitle,
            style: TextStyle(color: cs.onSurface),
          ),
          content: Text(
            loc.roomsDeletePostMessage,
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.9)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                loc.commonCancel,
                style: TextStyle(color: cs.onSurface),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                loc.roomsDeletePost,
                style: TextStyle(color: cs.primary),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final roomId = _getRoomId();
    if (roomId.isEmpty) return;
    final ok = await FirebaseDataService.deleteRoomPost(
      subjectId: roomId,
      postId: postId,
    );
    if (ok) await _loadPosts();
  }

  IconData _getFileIcon(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    if (extension == 'pdf') {
      return Icons.picture_as_pdf;
    } else if (extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'gif' ||
        extension == 'webp') {
      return Icons.image;
    }
    return Icons.attach_file;
  }

  Future<void> _showReplyDialog(String postId) async {
    final user = ref.read(userProvider);
    final email = user?.email ?? '';
    final displayName = user?.displayName ?? '';

    final replyCtrl = TextEditingController();

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(ctx)!.roomsReplyTitle,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(ctx).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: replyCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(ctx)!.roomsReplyHint,
                  filled: true,
                  fillColor: Theme.of(ctx).brightness == Brightness.dark
                      ? Theme.of(ctx).cardColor
                      : Theme.of(ctx).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final text = replyCtrl.text.trim();
                        if (text.isEmpty) return;
                        final reply = {
                          'body': text,
                          'authorEmail': email,
                          'authorName': displayName,
                          'createdAt': DateTime.now().toIso8601String(),
                        };
                        final roomId = _getRoomId();
                        final saved = await FirebaseDataService.saveRoomReply(
                          subjectId: roomId,
                          postId: postId,
                          reply: reply,
                        );
                        Navigator.of(ctx).pop(saved);
                      },
                      child: Text(AppLocalizations.of(ctx)!.roomsReplyButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (ok == true) await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final rawTitle =
        widget.subject['nome']?.toString() ??
        widget.subject['atividade']?.toString() ??
        '';
    final title = rawTitle.isNotEmpty ? rawTitle : loc.roomsNoName;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryBackground,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _posts.isEmpty
            ? Center(
                child: Text(
                  loc.roomsNoPosts,
                  style: GoogleFonts.poppins(color: cs.secondaryText),
                ),
              )
            : ListView.separated(
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final p = _posts[idx];
                  final postTitleRaw = p['title']?.toString().trim() ?? '';
                  final postTitle = postTitleRaw.isNotEmpty
                      ? postTitleRaw
                      : loc.activityUntitled;
                  final author =
                      p['authorName'] ?? p['authorEmail'] ?? loc.roomsAnonymous;
                  final postAuthorEmail = p['authorEmail']?.toString() ?? '';
                  final currentUserEmail = ref.read(userProvider)?.email ?? '';
                  final isAuthor =
                      postAuthorEmail.isNotEmpty &&
                      postAuthorEmail == currentUserEmail;
                  final created = DateTime.tryParse(
                    p['createdAt']?.toString() ?? '',
                  );
                  final when = created != null
                      ? '${created.day}/${created.month} ${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}'
                      : '';
                  // prepare replies list (if any)
                  List<Map<String, dynamic>> repliesList = [];
                  final repliesRaw = p['replies'];
                  if (repliesRaw != null && repliesRaw is Map) {
                    repliesRaw.forEach((k, v) {
                      if (v is Map) {
                        final item = Map<String, dynamic>.from(v);
                        item['id'] = k;
                        repliesList.add(item);
                      }
                    });
                    repliesList.sort((a, b) {
                      final aTs =
                          DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
                          DateTime(1970);
                      final bTs =
                          DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
                          DateTime(1970);
                      return aTs.compareTo(bTs);
                    });
                  }

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1A1F24)
                          : cs.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                postTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            if (isAuthor)
                              PopupMenuButton<int>(
                                onSelected: (v) {
                                  if (v == 1) {
                                    _deletePost(p['id']?.toString() ?? '');
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(loc.roomsDeletePost),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if ((p['body'] ?? '').toString().isNotEmpty)
                          Text(
                            p['body'] ?? '',
                            style: GoogleFonts.poppins(
                              color: cs.onSurface.withValues(alpha: 0.9),
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (p['attachmentUrl'] != null)
                          GestureDetector(
                            onTap: () async {
                              final attachmentId = p['attachmentUrl']
                                  ?.toString();
                              if (attachmentId == null) return;

                              // Mostrar loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              try {
                                final roomId = _getRoomId();
                                final bytes =
                                    await FirebaseDataService.downloadRoomAttachment(
                                      subjectId: roomId,
                                      attachmentId: attachmentId,
                                    );

                                if (!mounted) return;
                                Navigator.of(context).pop(); // Fechar loading

                                if (bytes == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(loc.somethingWrong)),
                                  );
                                  return;
                                }

                                // Detectar tipo de arquivo
                                final filename =
                                    p['attachmentName']?.toString() ?? '';
                                final extension = filename
                                    .toLowerCase()
                                    .split('.')
                                    .last;
                                String mimeType;
                                if (extension == 'pdf') {
                                  mimeType = 'application/pdf';
                                } else if (extension == 'jpg' ||
                                    extension == 'jpeg') {
                                  mimeType = 'image/jpeg';
                                } else if (extension == 'png') {
                                  mimeType = 'image/png';
                                } else if (extension == 'gif') {
                                  mimeType = 'image/gif';
                                } else if (extension == 'webp') {
                                  mimeType = 'image/webp';
                                } else {
                                  mimeType = 'application/octet-stream';
                                }

                                // Na web, compartilhar o arquivo em memória para download/abertura
                                if (kIsWeb) {
                                  try {
                                    final xf = XFile.fromData(
                                      bytes,
                                      name: filename.isNotEmpty
                                          ? filename
                                          : 'arquivo',
                                      mimeType: mimeType,
                                    );
                                    // ignore: deprecated_member_use
                                    await Share.shareXFiles([xf]);
                                  } catch (e) {
                                    if (kDebugMode) {
                                      debugPrint(
                                        'Erro ao compartilhar arquivo na web: $e',
                                      );
                                    }
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(loc.somethingWrong),
                                      ),
                                    );
                                  }
                                } else {
                                  // Mobile/Desktop: salvar arquivo temporariamente e abrir
                                  try {
                                    final dir = await getTemporaryDirectory();
                                    final file = File('${dir.path}/$filename');
                                    await file.writeAsBytes(bytes);

                                    final result = await OpenFilex.open(
                                      file.path,
                                    );

                                    if (result.type != ResultType.done) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            result.message.isEmpty
                                                ? 'Não foi possível abrir o arquivo'
                                                : result.message,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (kDebugMode) {
                                      debugPrint(
                                        'Erro ao salvar/abrir arquivo: $e',
                                      );
                                    }
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(loc.somethingWrong),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  debugPrint('Erro ao abrir PDF: $e');
                                }
                                if (!mounted) return;
                                Navigator.of(context).pop(); // Fechar loading
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(loc.somethingWrong)),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  _getFileIcon(
                                    p['attachmentName']?.toString() ?? '',
                                  ),
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    p['attachmentName']?.toString() ??
                                        loc.roomsAttachmentDefaultName,
                                    style: GoogleFonts.poppins(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.open_in_new,
                                  size: 18,
                                  color: cs.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),

                        // author / time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              author,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: cs.secondaryText,
                              ),
                            ),
                            Text(
                              when,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: cs.secondaryText,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // actions: responder
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _showReplyDialog(p['id']?.toString() ?? ''),
                              icon: Icon(
                                Icons.reply,
                                size: 18,
                                color: cs.primary,
                              ),
                              label: Text(
                                loc.roomsRespondAction,
                                style: GoogleFonts.poppins(color: cs.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (repliesList.isNotEmpty)
                              Text(
                                loc.roomsRepliesCount(repliesList.length),
                                style: GoogleFonts.poppins(
                                  color: cs.secondaryText,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // replies
                        if (repliesList.isNotEmpty)
                          Column(
                            children: repliesList.map((r) {
                              final rAuthor =
                                  r['authorName'] ??
                                  r['authorEmail'] ??
                                  loc.roomsAnonymous;
                              final rCreated = DateTime.tryParse(
                                r['createdAt']?.toString() ?? '',
                              );
                              final rWhen = rCreated != null
                                  ? '${rCreated.day}/${rCreated.month} ${rCreated.hour.toString().padLeft(2, '0')}:${rCreated.minute.toString().padLeft(2, '0')}'
                                  : '';
                              return Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Theme.of(context).cardColor
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primaryBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r['body'] ?? '',
                                      style: GoogleFonts.poppins(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          rAuthor,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: cs.secondaryText,
                                          ),
                                        ),
                                        Text(
                                          rWhen,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: cs.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: cs.primary,
        onPressed: _showNewPostDialog,
        icon: const Icon(Icons.add_comment_rounded),
        label: Text(loc.roomsNewPostFab),
      ),
    );
  }
}
