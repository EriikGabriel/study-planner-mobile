import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/providers/user_provider.dart';
import 'package:study_planner/services/firebase_data_service.dart';
import 'package:study_planner/theme/app_theme.dart';
import 'package:study_planner/utils/file_reader.dart';
import 'package:url_launcher/url_launcher.dart';

/// Salas: lista de disciplinas do usuário e, ao entrar, exibe posts (resumos/perguntas)
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
                    'Nenhuma disciplina encontrada',
                    style: GoogleFonts.poppins(
                      color: cs.onSurface.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: widget.onRefresh,
                    icon: Icon(Icons.refresh, color: cs.onSurface),
                    label: Text(
                      'Recarregar',
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
                final title = s['nome'] ?? s['atividade'] ?? 'Sem nome';
                final subtitle =
                    'Turma ${s['turma'] ?? '-'} • ${s['ano'] ?? '-'} / ${s['periodo'] ?? '-'}';
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RoomDetailPage(subject: s),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withOpacity(0.03),
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

  /// Gera um ID único para a sala baseado na disciplina, turma, ano e período
  /// Isso garante que todos os alunos da mesma turma compartilhem a mesma sala
  String _getRoomId() {
    final nome = widget.subject['nome']?.toString() ?? '';
    final turma = widget.subject['turma']?.toString() ?? '';
    final ano = widget.subject['ano']?.toString() ?? '';
    final periodo = widget.subject['periodo']?.toString() ?? '';
    
    // Normaliza o nome removendo espaços e caracteres especiais
    final nomeNormalizado = nome
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
    
    // Cria um ID único: nome_turma_ano_periodo
    return '${nomeNormalizado}_${turma}_${ano}_${periodo}';
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

            Future<void> pickPdf() async {
              final res = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
                withData: true,
              );
              if (res == null) return;
              final file = res.files.first;
              Uint8List? data = file.bytes;
              final path = file.path;
              // if bytes not provided (some mobile platforms), try reading from path
              if (data == null && path != null) {
                try {
                  data = await readFileBytes(path);
                } catch (_) {
                  data = null;
                }
              }
              // update UI with file name/path even if bytes are not available yet
              setState2(() {
                pickedName = file.name;
                pickedPath = path;
                pickedData = data; // may be null on some platforms
              });
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
                      'Novo post',
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
                        hintText: 'Título',
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
                        hintText: 'Escreva sua pergunta ou resumo...',
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
                          onPressed: pickPdf,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Anexar PDF'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pickedName ?? 'Nenhum anexo',
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
                                    if (title.isEmpty &&
                                        body.isEmpty &&
                                        pickedData == null)
                                      return;
                                    setState2(() => uploading = true);
                                    String? attachmentUrl;
                                    String? attachmentName;
                                    final roomId = _getRoomId();
                                    if (pickedName != null &&
                                        roomId.isNotEmpty) {
                                      // ensure we have bytes to upload: try reading from pickedPath if needed
                                      if (pickedData == null &&
                                          pickedPath != null) {
                                        try {
                                          pickedData = await readFileBytes(
                                            pickedPath!,
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            ctx2,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Não foi possível ler o arquivo anexado',
                                              ),
                                            ),
                                          );
                                          setState2(() => uploading = false);
                                          return;
                                        }
                                      }

                                      // file size check (10 MB)
                                      if (pickedData != null &&
                                          pickedData!.lengthInBytes >
                                              maxFileBytes) {
                                        ScaffoldMessenger.of(ctx2).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Arquivo muito grande — máximo permitido: 10 MB',
                                            ),
                                          ),
                                        );
                                        setState2(() => uploading = false);
                                        return;
                                      }

                                      if (pickedData != null) {
                                        final url =
                                            await FirebaseDataService.uploadRoomAttachment(
                                              subjectId: roomId,
                                              filename:
                                                  pickedName ??
                                                  'attachment.pdf',
                                              data: pickedData!,
                                              onProgress: (p) {
                                                setState2(() {
                                                  uploadProgress = p;
                                                });
                                              },
                                            );
                                        attachmentUrl = url;
                                        attachmentName = pickedName;
                                      }
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
                                          attachmentName ?? 'attachment.pdf';
                                    }
                                    final saved =
                                        await FirebaseDataService.saveRoomPost(
                                          subjectId: roomId,
                                          post: post,
                                        );
                                    setState2(() => uploading = false);
                                    Navigator.of(ctx2).pop(saved);
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
                                            : 'Enviando...',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  )
                                : const Text('Publicar'),
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
        return AlertDialog(
          backgroundColor: Theme.of(ctx).brightness == Brightness.dark
              ? Theme.of(ctx).cardColor
              : cs.surface,
          title: Text('Excluir post', style: TextStyle(color: cs.onSurface)),
          content: Text(
            'Deseja excluir este post?',
            style: TextStyle(color: cs.onSurface.withOpacity(0.9)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Cancelar', style: TextStyle(color: cs.onSurface)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Excluir', style: TextStyle(color: cs.primary)),
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
                'Responder',
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
                  hintText: 'Escreva sua resposta...',
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
                      child: const Text('Responder'),
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
    final title =
        widget.subject['nome'] ?? widget.subject['atividade'] ?? 'Sala';
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
                  'Nenhum post ainda. Crie o primeiro!',
                  style: GoogleFonts.poppins(color: cs.secondaryText),
                ),
              )
            : ListView.separated(
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final p = _posts[idx];
                  final author = p['authorName'] ?? p['authorEmail'] ?? 'Anon';
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
                      color: cs.surface,
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
                                p['title'] ?? '(sem título)',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            PopupMenuButton<int>(
                              onSelected: (v) {
                                if (v == 1)
                                  _deletePost(p['id']?.toString() ?? '');
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text('Excluir'),
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
                              color: cs.onSurface.withOpacity(0.9),
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (p['attachmentUrl'] != null)
                          GestureDetector(
                            onTap: () async {
                              final url = p['attachmentUrl']?.toString();
                              if (url == null) return;
                              final uri = Uri.tryParse(url);
                              if (uri == null) return;
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf, color: cs.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    p['attachmentName']?.toString() ??
                                        'Anexo.pdf',
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
                                'Responder',
                                style: GoogleFonts.poppins(color: cs.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (repliesList.isNotEmpty)
                              Text(
                                '${repliesList.length} resposta${repliesList.length == 1 ? '' : 's'}',
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
                                  r['authorName'] ?? r['authorEmail'] ?? 'Anon';
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
                                        color: cs.onSurface.withOpacity(0.9),
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
        label: const Text('Novo post'),
      ),
    );
  }
}
